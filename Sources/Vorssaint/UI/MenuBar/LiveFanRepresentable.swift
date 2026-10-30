// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import AppKit
import SwiftUI

struct LiveFanRepresentable: NSViewRepresentable {
    var interactive: Bool
    var percent: Int?
    var interactionTrigger = 0
    var holdLowSeconds: TimeInterval = 0
    /// Dark-pill Settings mockups pass white.
    var tint: NSColor?

    init(interactive: Bool, percent: Int? = nil, interactionTrigger: Int = 0,
         holdLowSeconds: TimeInterval = 0, tint: NSColor? = nil) {
        self.interactive = interactive
        self.percent = percent
        self.interactionTrigger = interactionTrigger
        self.holdLowSeconds = holdLowSeconds
        self.tint = tint
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeNSView(context: Context) -> LiveFanView {
        let view = LiveFanView(preview: true)
        context.coordinator.view = view
        context.coordinator.interactive = interactive
        context.coordinator.lastInteractionTrigger = interactionTrigger
        if let tint { view.setTint(tint) }
        let click = NSClickGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleClick(_:))
        )
        view.addGestureRecognizer(click)
        if let percent { view.setValue(percent) }
        if holdLowSeconds > 0 {
            context.coordinator.startLowHold(seconds: holdLowSeconds, on: view)
        }
        return view
    }

    func updateNSView(_ nsView: LiveFanView, context: Context) {
        context.coordinator.view = nsView
        context.coordinator.interactive = interactive
        if let tint { nsView.setTint(tint) }
        if interactionTrigger > context.coordinator.lastInteractionTrigger {
            context.coordinator.lastInteractionTrigger = interactionTrigger
            context.coordinator.cancelLowHold()
            nsView.previewInteracted()
        }
        if let percent { nsView.setValue(percent) }
    }

    static func dismantleNSView(_ nsView: LiveFanView, coordinator: Coordinator) {
        coordinator.cancelLowHold()
    }

    @MainActor
    final class Coordinator: NSObject {
        weak var view: LiveFanView?
        var interactive = false
        var lastInteractionTrigger = 0
        private var holdStopWork: DispatchWorkItem?

        @objc func handleClick(_ recognizer: NSClickGestureRecognizer) {
            guard interactive else { return }
            cancelLowHold()
            view?.previewInteracted()
        }

        func startLowHold(seconds: TimeInterval, on view: LiveFanView) {
            cancelLowHold()
            DispatchQueue.main.async { [weak view] in
                view?.setValue(25)
            }
            let work = DispatchWorkItem { [weak view] in
                view?.setValue(0)
            }
            holdStopWork = work
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: work)
        }

        func cancelLowHold() {
            holdStopWork?.cancel()
            holdStopWork = nil
        }
    }
}
