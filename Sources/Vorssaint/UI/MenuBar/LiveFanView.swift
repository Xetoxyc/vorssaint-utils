// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import AppKit
import QuartzCore

final class LiveFanView: NSView {
    private static let spinAnimationKey = "liveFan.spin"
    private static let stopSettleAnimationKey = "liveFan.stopSettle"

    private static let transitionDuration: CFTimeInterval = 2.0
    private static let holdDuration: CFTimeInterval = 2.0
    private static let revolutionDurationAtFullSpeed: CFTimeInterval = 0.6
    private static let minSpinSpeed: Double = 0.15
    private static let previewStep: Int = 25
    private static let updateThreshold: Int = 3
    private static let overshootRadians: Double = 0.06

    private let image: NSImage?
    private let symbolSize: NSSize
    private let containerLayer: CALayer
    private let rotorLayer: CALayer
    private let maskLayer: CALayer
    private let isPreview: Bool
    private static let horizontalPadding: CGFloat = 2
    private static let verticalPadding: CGFloat = 1

    private var value: Int = 0
    private var tintColor: NSColor = .textColor
    private var speedTimer: Timer?
    private var previewStopWorkItem: DispatchWorkItem?

    init(preview: Bool = false) {
        let configuration = NSImage.SymbolConfiguration(pointSize: 14, weight: .regular)
        let icon = NSImage(systemSymbolName: "fan.fill", accessibilityDescription: nil)
        let image = icon?.withSymbolConfiguration(configuration) ?? icon
        let symbolSize = image?.size ?? NSSize(width: 16, height: 16)
        let width = ceil(symbolSize.width)
        let hub = Self.alphaWeightedCentroid(of: image, size: symbolSize)

        self.image = image
        self.symbolSize = symbolSize
        self.containerLayer = CALayer()
        self.rotorLayer = CALayer()
        self.maskLayer = CALayer()
        self.isPreview = preview

        super.init(frame: NSRect(
            x: 0,
            y: 0,
            width: width + (2 * Self.horizontalPadding),
            height: ceil(symbolSize.height) + (2 * Self.verticalPadding)
        ))

        self.wantsLayer = true
        self.clipsToBounds = false
        self.containerLayer.bounds = self.bounds
        self.containerLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        self.containerLayer.actions = [
            "position": NSNull(),
            "bounds": NSNull()
        ]
        self.rotorLayer.bounds = NSRect(origin: .zero, size: symbolSize)
        self.rotorLayer.anchorPoint = CGPoint(
            x: hub.x / symbolSize.width,
            y: hub.y / symbolSize.height
        )
        self.rotorLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        self.rotorLayer.allowsEdgeAntialiasing = true
        self.rotorLayer.actions = Self.disabledLayerActions
        self.rotorLayer.speed = 0

        self.maskLayer.frame = self.rotorLayer.bounds
        self.maskLayer.contentsGravity = .resize
        self.maskLayer.actions = Self.disabledLayerActions
        self.rotorLayer.mask = self.maskLayer
        self.containerLayer.addSublayer(self.rotorLayer)
        self.layer?.addSublayer(self.containerLayer)
        self.refreshLayerContents()
        self.refreshTint()
    }

    override var intrinsicContentSize: NSSize {
        let size = self.symbolSize
        return NSSize(
            width: ceil(size.width) + (2 * Self.horizontalPadding),
            height: ceil(size.height) + (2 * Self.verticalPadding)
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.speedTimer?.invalidate()
        self.previewStopWorkItem?.cancel()
    }

    /// The status button owns clicks in the menu bar.
    override func hitTest(_ point: NSPoint) -> NSView? {
        self.isPreview ? super.hitTest(point) : nil
    }

    override func layout() {
        super.layout()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.containerLayer.bounds = self.bounds
        self.containerLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        self.rotorLayer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        CATransaction.commit()
    }

    override func viewWillMove(toWindow newWindow: NSWindow?) {
        super.viewWillMove(toWindow: newWindow)
        guard newWindow == nil else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self, self.window == nil else { return }
            self.halt()
        }
    }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        guard self.window != nil else { return }
        if self.value > 0 {
            self.applyPercentage(self.value, animated: true)
        }
    }

    override func viewDidChangeBackingProperties() {
        super.viewDidChangeBackingProperties()
        self.refreshLayerContents()
    }

    override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        self.refreshTint()
    }

    func setTint(_ color: NSColor) {
        self.tintColor = color
        self.refreshTint()
    }

    func setValue(_ newValue: Int) {
        let clamped = max(0, min(100, newValue))
        let update = { [weak self] in
            guard let self else { return }
            let crossedIdle = (self.value == 0) != (clamped == 0)
            guard crossedIdle || abs(self.value - clamped) >= Self.updateThreshold else { return }
            self.value = clamped
            guard self.window != nil else { return }
            self.applyPercentage(clamped, animated: true)
        }
        if Thread.isMainThread {
            update()
        } else {
            DispatchQueue.main.async(execute: update)
        }
    }

    func previewInteracted() {
        guard self.isPreview else { return }

        self.previewStopWorkItem?.cancel()
        self.previewStopWorkItem = nil

        let next = min(100, self.value + Self.previewStep)
        self.value = next
        self.applyPercentage(next, animated: true)

        let work = DispatchWorkItem { [weak self] in
            guard let self else { return }
            self.previewStopWorkItem = nil
            self.value = 0
            self.applyPercentage(0, animated: true)
        }
        self.previewStopWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.holdDuration, execute: work)
    }

    private static var disabledLayerActions: [String: CAAction] {
        [
            "position": NSNull(),
            "bounds": NSNull(),
            "transform": NSNull(),
            "speed": NSNull(),
            "contents": NSNull(),
            "backgroundColor": NSNull()
        ]
    }

    private static func alphaWeightedCentroid(of image: NSImage?, size: NSSize) -> CGPoint {
        guard let image else {
            return CGPoint(x: size.width / 2, y: size.height / 2)
        }

        let scale = 8
        let pixelWidth = max(1, Int(ceil(size.width * CGFloat(scale))))
        let pixelHeight = max(1, Int(ceil(size.height * CGFloat(scale))))
        guard let bitmap = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: pixelWidth,
            pixelsHigh: pixelHeight,
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .deviceRGB,
            bytesPerRow: pixelWidth * 4,
            bitsPerPixel: 32
        ), let context = NSGraphicsContext(bitmapImageRep: bitmap) else {
            return CGPoint(x: size.width / 2, y: size.height / 2)
        }

        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = context
        context.cgContext.scaleBy(x: CGFloat(scale), y: CGFloat(scale))
        let contentsScale = NSScreen.main?.backingScaleFactor ?? 2
        let mask = CALayer()
        mask.frame = NSRect(origin: .zero, size: size)
        mask.contents = image.layerContents(forContentsScale: contentsScale)
        mask.contentsScale = contentsScale
        mask.contentsGravity = .resize
        let renderedImage = CALayer()
        renderedImage.bounds = NSRect(origin: .zero, size: size)
        renderedImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        renderedImage.backgroundColor = NSColor.white.cgColor
        renderedImage.mask = mask
        renderedImage.render(in: context.cgContext)
        context.flushGraphics()
        NSGraphicsContext.restoreGraphicsState()

        guard let data = bitmap.bitmapData else {
            return CGPoint(x: size.width / 2, y: size.height / 2)
        }
        var alphaSum = 0.0
        var weightedX = 0.0
        var weightedY = 0.0
        for row in 0..<pixelHeight {
            for column in 0..<pixelWidth {
                let alpha = Double(data[(row * bitmap.bytesPerRow) + (column * 4) + 3])
                alphaSum += alpha
                weightedX += alpha * (Double(column) + 0.5)
                weightedY += alpha * (Double(pixelHeight - 1 - row) + 0.5)
            }
        }
        guard alphaSum > 0 else {
            return CGPoint(x: size.width / 2, y: size.height / 2)
        }
        return CGPoint(
            x: weightedX / alphaSum / Double(scale),
            y: weightedY / alphaSum / Double(scale)
        )
    }

    private static func normalizedSpeed(for percentage: Int) -> Double {
        let clamped = max(0, min(100, percentage))
        guard clamped > 0 else { return 0 }
        let ratio = Double(clamped) / 100.0
        return Self.minSpinSpeed + (1.0 - Self.minSpinSpeed) * ratio
    }

    private static func currentAngle(of layer: CALayer) -> Double {
        (layer.presentation()?.value(forKeyPath: "transform.rotation.z") as? NSNumber)?.doubleValue
            ?? (layer.value(forKeyPath: "transform.rotation.z") as? NSNumber)?.doubleValue
            ?? 0
    }

    private func refreshLayerContents() {
        let scale = self.window?.backingScaleFactor ?? NSScreen.main?.backingScaleFactor ?? 2
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.rotorLayer.contentsScale = scale
        self.maskLayer.contents = self.image?.layerContents(forContentsScale: scale)
        self.maskLayer.contentsScale = scale
        CATransaction.commit()
    }

    private func refreshTint() {
        var color = self.tintColor.cgColor
        self.effectiveAppearance.performAsCurrentDrawingAppearance {
            color = self.tintColor.cgColor
        }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.rotorLayer.backgroundColor = color
        CATransaction.commit()
    }

    private func halt() {
        self.speedTimer?.invalidate()
        self.speedTimer = nil
        let layer = self.rotorLayer
        let angle = Self.currentAngle(of: layer)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        layer.removeAllAnimations()
        layer.timeOffset = 0
        layer.beginTime = 0
        layer.speed = 0
        layer.setValue(angle, forKeyPath: "transform.rotation.z")
        CATransaction.commit()
    }

    private func applyLayerSpeed(_ newSpeed: Float, to layer: CALayer, at media: CFTimeInterval = CACurrentMediaTime()) {
        let local = layer.convertTime(media, from: nil)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        layer.beginTime = media
        layer.timeOffset = local
        layer.speed = newSpeed
        CATransaction.commit()
    }

    private func ensureSpin(on layer: CALayer) {
        guard layer.animation(forKey: Self.spinAnimationKey) == nil else { return }
        let angle = (layer.value(forKeyPath: "transform.rotation.z") as? NSNumber)?.doubleValue ?? 0
        let spin = CABasicAnimation(keyPath: "transform.rotation.z")
        spin.fromValue = angle
        spin.byValue = -2.0 * Double.pi
        spin.duration = Self.revolutionDurationAtFullSpeed
        spin.repeatCount = .infinity
        spin.timingFunction = CAMediaTimingFunction(name: .linear)
        spin.isRemovedOnCompletion = false
        layer.add(spin, forKey: Self.spinAnimationKey)
    }

    private func setSpinSpeed(
        _ target: Double,
        on layer: CALayer,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        self.speedTimer?.invalidate()
        self.speedTimer = nil

        let destination = Float(target)
        guard animated else {
            self.applyLayerSpeed(destination, to: layer)
            completion?()
            return
        }

        // Presentation speed can lag a frame behind the model and hitch.
        let from = layer.speed
        if abs(from - destination) < 0.001 {
            self.applyLayerSpeed(destination, to: layer)
            completion?()
            return
        }

        let start = CACurrentMediaTime()
        let timer = Timer(timeInterval: 1.0 / 60.0, repeats: true) { [weak self] timer in
            guard let self else {
                timer.invalidate()
                return
            }
            let media = CACurrentMediaTime()
            let t = min(1, (media - start) / Self.transitionDuration)
            let eased = t * t * (3 - 2 * t)
            let current = t >= 1 ? destination : from + (destination - from) * Float(eased)
            self.applyLayerSpeed(current, to: self.rotorLayer, at: media)
            if t >= 1 {
                timer.invalidate()
                if self.speedTimer === timer {
                    self.speedTimer = nil
                }
                completion?()
            }
        }
        self.speedTimer = timer
        RunLoop.main.add(timer, forMode: .common)
        RunLoop.main.add(timer, forMode: .eventTracking)
    }

    private func applyPercentage(_ percentage: Int, animated: Bool) {
        let targetSpeed = Self.normalizedSpeed(for: percentage)
        let layer = self.rotorLayer

        guard targetSpeed > 0 else {
            self.speedTimer?.invalidate()
            self.speedTimer = nil

            guard layer.animation(forKey: Self.spinAnimationKey) != nil
                    || layer.animation(forKey: Self.stopSettleAnimationKey) != nil else {
                return
            }

            let previousSpeed = Double(layer.speed)
            let angle = Self.currentAngle(of: layer)
            layer.removeAnimation(forKey: Self.spinAnimationKey)
            layer.removeAnimation(forKey: Self.stopSettleAnimationKey)

            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layer.timeOffset = 0
            layer.beginTime = 0
            layer.speed = 1
            layer.setValue(angle, forKeyPath: "transform.rotation.z")
            CATransaction.commit()

            if animated {
                self.animateContinuousStop(on: layer, fromAngle: angle, previousSpeed: previousSpeed)
            } else {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                layer.speed = 0
                CATransaction.commit()
            }
            return
        }

        let isSpinning = layer.animation(forKey: Self.spinAnimationKey) != nil
        if !isSpinning {
            if layer.animation(forKey: Self.stopSettleAnimationKey) != nil {
                let angle = Self.currentAngle(of: layer)
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                layer.setValue(angle, forKeyPath: "transform.rotation.z")
                CATransaction.commit()
                layer.removeAnimation(forKey: Self.stopSettleAnimationKey)
            }
            let initialSpeed = animated ? Float(targetSpeed * 0.01) : Float(targetSpeed)
            let media = CACurrentMediaTime()
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layer.timeOffset = 0
            layer.beginTime = media
            layer.speed = initialSpeed
            CATransaction.commit()
            self.ensureSpin(on: layer)
        }

        self.setSpinSpeed(targetSpeed, on: layer, animated: animated)
    }

    private func animateContinuousStop(on layer: CALayer, fromAngle: Double, previousSpeed: Double) {
        let maxOmega = -(2.0 * Double.pi) / Self.revolutionDurationAtFullSpeed
        let omega0 = maxOmega * max(0, previousSpeed)
        let decelerationShare = 0.8
        let decelerationTime = Self.transitionDuration * decelerationShare
        let peakAngle = fromAngle + 0.5 * omega0 * decelerationTime
        let restAngle = peakAngle + Self.overshootRadians

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        layer.setValue(restAngle, forKeyPath: "transform.rotation.z")
        CATransaction.commit()

        let settle = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        settle.values = [fromAngle, peakAngle, restAngle]
        settle.keyTimes = [0.0, NSNumber(value: decelerationShare), 1.0]
        settle.timingFunctions = [
            CAMediaTimingFunction(controlPoints: 1.0/3.0, 2.0/3.0, 2.0/3.0, 1.0),
            CAMediaTimingFunction(name: .easeInEaseOut)
        ]
        settle.duration = Self.transitionDuration
        settle.fillMode = .forwards
        settle.isRemovedOnCompletion = false
        settle.delegate = StopSettleDelegate { [weak layer] in
            guard let layer else { return }
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layer.removeAnimation(forKey: LiveFanView.stopSettleAnimationKey)
            layer.speed = 0
            layer.setValue(restAngle, forKeyPath: "transform.rotation.z")
            CATransaction.commit()
        }
        layer.add(settle, forKey: Self.stopSettleAnimationKey)
    }
}

private final class StopSettleDelegate: NSObject, CAAnimationDelegate {
    private let onStop: () -> Void

    init(onStop: @escaping () -> Void) {
        self.onStop = onStop
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.onStop()
    }
}
