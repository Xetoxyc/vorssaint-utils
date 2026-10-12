// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Foundation

struct NotchAccountStrings {
    let title: String
    let hubDescription: String
    let settingsDescription: String
    let empty: String
    let claudeSessionsFormat: String
    let codexSessionsFormat: String
    let auto: String
    let active: String
    let needsLogin: String
    let needsLoginHint: String
    let noUsage: String
    let switchToFormat: String
    let unsavedFormat: String
    let save: String
    let settings: String
    let usageRateLimited: String
    let usageToolMissingFormat: String
    let usageUnavailable: String
    let switchBusyFormat: String
    let switchUnsupportedFormat: String
    let switchUnavailable: String
    let switchTargetMissing: String
    let saveFailedFormat: String
    let removeFailed: String
    let switchedFormat: String
    let previousAtFormat: String
    let exhaustedFormat: String
    let nextResetFormat: String
    let signedInFormat: String
    let notSignedIn: String
    let apiKeyLogin: String
    let saveThisLogin: String
    let labelPlaceholder: String
    let remove: String
    let removeConfirmFormat: String
    let removeHint: String
    let autoSwapFormat: String
    let autoSwapHint: String
    let threshold: String
    let privacy: String
    let howTo: String

    func switchTo(_ login: String) -> String { String(format: switchToFormat, login) }
    func unsaved(_ email: String) -> String { String(format: unsavedFormat, email) }
    func switched(_ provider: String, to login: String) -> String { String(format: switchedFormat, provider, login) }
    func previousAt(_ login: String, used: String) -> String { String(format: previousAtFormat, login, used) }
    func exhausted(_ provider: String) -> String { String(format: exhaustedFormat, provider) }
    func nextReset(_ time: String) -> String { String(format: nextResetFormat, time) }
    func signedIn(_ email: String) -> String { String(format: signedInFormat, email) }
    func removeConfirm(_ login: String) -> String { String(format: removeConfirmFormat, login) }
    func autoSwap(_ provider: String) -> String { String(format: autoSwapFormat, provider) }

    /// What a provider's running sessions do after a swap: Claude Code reads
    /// its login again on its own, a Codex session keeps the one it started with.
    func sessions(_ count: Int, provider: AgentProvider) -> String {
        String(format: provider == .claude ? claudeSessionsFormat : codexSessionsFormat, "\(count)")
    }

    /// Why a login's limits are missing, for the person; the failure's own
    /// text is for logs.
    func message(_ failure: AgentUsageFailure, provider: AgentProvider) -> String {
        switch failure {
        case .needsLogin: return needsLoginHint
        case .rateLimited: return usageRateLimited
        case .toolMissing: return String(format: usageToolMissingFormat, provider.displayName)
        case .unavailable: return usageUnavailable
        }
    }

    func message(_ error: AgentAccountError) -> String {
        switch error {
        case .switchFailed(let provider, let failure):
            let name = provider?.displayName ?? ""
            switch failure {
            case .busy: return String(format: switchBusyFormat, name)
            case .unsupported: return String(format: switchUnsupportedFormat, name)
            case .copyUnavailable: return switchUnavailable
            case .targetMissing: return switchTargetMissing
            case .needsLogin: return needsLoginHint
            }
        case .saveFailed(let provider, _): return String(format: saveFailedFormat, provider.displayName)
        case .removeFailed: return removeFailed
        }
    }
}

extension FeatureStrings {
    static func notchAccounts(_ language: AppLanguage) -> NotchAccountStrings {
        switch language {
        case .enUS: return .enUS
        case .ptBR: return .ptBR
        case .es: return .es
        case .sk: return .sk
        case .de: return .de
        case .fr: return .fr
        case .it: return .it
        case .ru: return .ru
        case .tr: return .tr
        case .ja: return .ja
        case .ko: return .ko
        case .uk: return .uk
        case .zhHans: return .zhHans
        case .zhTW: return .zhTW
        case .zhHK: return .zhHK
        }
    }
}

extension NotchAccountStrings {
    static let enUS = NotchAccountStrings(
        title: "Agent Accounts",
        hubDescription: "Keep several Claude Code and Codex logins, see each one’s limits and swap between them in the Dynamic Island, by tap or automatically.",
        settingsDescription: "Keeps several logins for Claude Code and Codex, shows each one’s limits and swaps the one in use.",
        empty: "No saved logins yet. Save the one you use now in Settings, then run claude auth login or codex login in a terminal for the next.",
        claudeSessionsFormat: "Sessions running: %@. They follow a swap within 30 s.",
        codexSessionsFormat: "Sessions running: %@. Restart them after a swap.",
        auto: "auto",
        active: "Active",
        needsLogin: "Needs login",
        needsLoginHint: "This login has expired. Sign in to it again in a terminal.",
        noUsage: "No usage yet",
        switchToFormat: "Switch to %@",
        unsavedFormat: "%@ is signed in and not saved",
        save: "Save",
        settings: "Agent Accounts settings",
        usageRateLimited: "Asked too often. Limits will be read again later.",
        usageToolMissingFormat: "%@ was not found on this Mac.",
        usageUnavailable: "Limits could not be read.",
        switchBusyFormat: "%@ is busy. Try again in a moment.",
        switchUnsupportedFormat: "%@ is signed in with an API key, which is left as it is.",
        switchUnavailable: "The login could not be swapped. Nothing was changed.",
        switchTargetMissing: "That login is no longer saved.",
        saveFailedFormat: "The %@ login could not be saved.",
        removeFailed: "The login could not be removed.",
        switchedFormat: "%1$@ switched to %2$@",
        previousAtFormat: "%1$@ at %2$@",
        exhaustedFormat: "All %@ logins near their limit",
        nextResetFormat: "Next reset %@",
        signedInFormat: "Signed in as %@",
        notSignedIn: "Not signed in",
        apiKeyLogin: "API key login, not supported",
        saveThisLogin: "Save this login",
        labelPlaceholder: "Label",
        remove: "Remove",
        removeConfirmFormat: "Remove %@?",
        removeHint: "Only the copy Vorssaint keeps is deleted. The login itself stays signed in.",
        autoSwapFormat: "Swap %@ automatically",
        autoSwapHint: "When the login in use nears its limit, the saved login with the most room takes over. This also happens while the display sleeps or the Mac is locked.",
        threshold: "Swap at",
        privacy: "While this section is on, Vorssaint sends each saved Claude login’s token to api.anthropic.com to read its limits and renews it at platform.claude.com when it expires. For a Codex login it starts Codex’s own tool. Nothing else leaves your Mac. Logins stay in your Keychain and in Vorssaint’s private folder, and are never part of a settings backup.",
        howTo: "To add another account, sign in to it in a terminal with claude auth login or codex login. Vorssaint notices the new login and offers to save it. Saved logins stay valid."
    )

    static let uk = NotchAccountStrings(
        title: "Облікові записи агентів",
        hubDescription: "Зберігайте кілька входів у Claude Code і Codex, стежте за лімітами кожного й перемикайте їх у Dynamic Island дотиком або автоматично.",
        settingsDescription: "Зберігає кілька входів у Claude Code і Codex, показує ліміти кожного й перемикає активний.",
        empty: "Збережених входів ще немає. Збережіть поточний у Налаштуваннях, а для наступного виконайте в терміналі claude auth login або codex login.",
        claudeSessionsFormat: "Запущено сеансів: %@. Вони підхоплять зміну за 30 с.",
        codexSessionsFormat: "Запущено сеансів: %@. Перезапустіть їх після зміни.",
        auto: "авто",
        active: "Активний",
        needsLogin: "Потрібен вхід",
        needsLoginHint: "Термін дії цього входу минув. Увійдіть знову в терміналі.",
        noUsage: "Даних про використання ще немає",
        switchToFormat: "Перемкнути на %@",
        unsavedFormat: "%@: вхід виконано, але не збережено",
        save: "Зберегти",
        settings: "Налаштування облікових записів агентів",
        usageRateLimited: "Забагато запитів. Ліміти буде прочитано пізніше.",
        usageToolMissingFormat: "%@ не знайдено на цьому Mac.",
        usageUnavailable: "Не вдалося прочитати ліміти.",
        switchBusyFormat: "%@ зараз зайнятий. Спробуйте за мить.",
        switchUnsupportedFormat: "%@ використовує вхід за ключем API, його залишено без змін.",
        switchUnavailable: "Не вдалося перемкнути вхід. Нічого не змінено.",
        switchTargetMissing: "Цей вхід більше не збережено.",
        saveFailedFormat: "Не вдалося зберегти вхід %@.",
        removeFailed: "Не вдалося вилучити вхід.",
        switchedFormat: "%1$@: перемкнуто на %2$@",
        previousAtFormat: "%1$@: %2$@",
        exhaustedFormat: "Усі входи %@ близькі до ліміту",
        nextResetFormat: "Наступне скидання %@",
        signedInFormat: "Виконано вхід як %@",
        notSignedIn: "Вхід не виконано",
        apiKeyLogin: "Вхід за ключем API, не підтримується",
        saveThisLogin: "Зберегти цей вхід",
        labelPlaceholder: "Мітка",
        remove: "Вилучити",
        removeConfirmFormat: "Вилучити %@?",
        removeHint: "Буде видалено лише копію, яку зберігає Vorssaint. Сам вхід залишиться активним.",
        autoSwapFormat: "Перемикати %@ автоматично",
        autoSwapHint: "Коли активний вхід наближається до ліміту, його замінює збережений вхід із найбільшим запасом. Це відбувається і тоді, коли дисплей у режимі сну або Mac заблоковано.",
        threshold: "Перемикати при",
        privacy: "Поки цей розділ увімкнено, Vorssaint надсилає токен кожного збереженого входу Claude на api.anthropic.com, щоб прочитати його ліміти, і поновлює його на platform.claude.com, коли термін дії минає. Для входу Codex запускається власний інструмент Codex. Більше нічого не залишає ваш Mac. Входи зберігаються у Вʼязці ключів і в приватній теці Vorssaint та ніколи не потрапляють у резервну копію налаштувань.",
        howTo: "Щоб додати ще один обліковий запис, увійдіть у нього в терміналі командою claude auth login або codex login. Vorssaint помітить новий вхід і запропонує зберегти його. Збережені входи залишаються чинними."
    )

    static let ptBR = NotchAccountStrings(
        title: "Contas de agentes",
        hubDescription: "Mantenha vários logins do Claude Code e do Codex, veja os limites de cada um e troque entre eles na Dynamic Island, com um toque ou automaticamente.",
        settingsDescription: "Mantém vários logins do Claude Code e do Codex, mostra os limites de cada um e troca o que está em uso.",
        empty: "Nenhum login salvo ainda. Salve o que você usa agora nos Ajustes e depois execute claude auth login ou codex login em um terminal para o próximo.",
        claudeSessionsFormat: "Sessões em execução: %@. Elas acompanham a troca em até 30 s.",
        codexSessionsFormat: "Sessões em execução: %@. Reinicie-as depois de uma troca.",
        auto: "auto",
        active: "Ativo",
        needsLogin: "Precisa de login",
        needsLoginHint: "Este login expirou. Entre nele de novo em um terminal.",
        noUsage: "Ainda sem uso",
        switchToFormat: "Trocar para %@",
        unsavedFormat: "%@ está conectado e não foi salvo",
        save: "Salvar",
        settings: "Ajustes das contas de agentes",
        usageRateLimited: "Muitas consultas. Os limites serão lidos de novo mais tarde.",
        usageToolMissingFormat: "%@ não foi encontrado neste Mac.",
        usageUnavailable: "Não foi possível ler os limites.",
        switchBusyFormat: "%@ está ocupado. Tente de novo em instantes.",
        switchUnsupportedFormat: "%@ está conectado com uma chave de API, que foi mantida como está.",
        switchUnavailable: "Não foi possível trocar o login. Nada foi alterado.",
        switchTargetMissing: "Esse login não está mais salvo.",
        saveFailedFormat: "Não foi possível salvar o login do %@.",
        removeFailed: "Não foi possível remover o login.",
        switchedFormat: "%1$@ trocou para %2$@",
        previousAtFormat: "%1$@ em %2$@",
        exhaustedFormat: "Todos os logins do %@ estão perto do limite",
        nextResetFormat: "Próxima renovação %@",
        signedInFormat: "Conectado como %@",
        notSignedIn: "Não conectado",
        apiKeyLogin: "Login com chave de API, não compatível",
        saveThisLogin: "Salvar este login",
        labelPlaceholder: "Rótulo",
        remove: "Remover",
        removeConfirmFormat: "Remover %@?",
        removeHint: "Só a cópia que o Vorssaint guarda é apagada. O login em si continua conectado.",
        autoSwapFormat: "Trocar %@ automaticamente",
        autoSwapHint: "Quando o login em uso se aproxima do limite, o login salvo com mais folga assume. Isso também acontece com a tela em repouso ou o Mac bloqueado.",
        threshold: "Trocar em",
        privacy: "Enquanto esta seção está ativada, o Vorssaint envia o token de cada login salvo do Claude para api.anthropic.com para ler os limites e o renova em platform.claude.com quando ele expira. Para um login do Codex, ele inicia a própria ferramenta do Codex. Nada mais sai do seu Mac. Os logins ficam nas suas Chaves e na pasta privada do Vorssaint e nunca entram em um backup dos ajustes.",
        howTo: "Para adicionar outra conta, entre nela em um terminal com claude auth login ou codex login. O Vorssaint percebe o novo login e oferece salvá-lo. Os logins salvos continuam válidos."
    )

    static let es = NotchAccountStrings(
        title: "Cuentas de agentes",
        hubDescription: "Guarda varios inicios de sesión de Claude Code y Codex, consulta los límites de cada uno y cambia entre ellos en la Dynamic Island, con un toque o automáticamente.",
        settingsDescription: "Guarda varios inicios de sesión de Claude Code y Codex, muestra los límites de cada uno y cambia el que está en uso.",
        empty: "Aún no hay inicios de sesión guardados. Guarda el que usas ahora en Ajustes y luego ejecuta claude auth login o codex login en un terminal para el siguiente.",
        claudeSessionsFormat: "Sesiones en ejecución: %@. Siguen el cambio en menos de 30 s.",
        codexSessionsFormat: "Sesiones en ejecución: %@. Reinícialas después de un cambio.",
        auto: "auto",
        active: "Activo",
        needsLogin: "Requiere iniciar sesión",
        needsLoginHint: "Este inicio de sesión ha caducado. Vuelve a iniciarlo en un terminal.",
        noUsage: "Aún sin uso",
        switchToFormat: "Cambiar a %@",
        unsavedFormat: "%@ tiene la sesión iniciada y no está guardado",
        save: "Guardar",
        settings: "Ajustes de cuentas de agentes",
        usageRateLimited: "Demasiadas consultas. Los límites se leerán de nuevo más tarde.",
        usageToolMissingFormat: "%@ no se ha encontrado en este Mac.",
        usageUnavailable: "No se han podido leer los límites.",
        switchBusyFormat: "%@ está ocupado. Inténtalo de nuevo en un momento.",
        switchUnsupportedFormat: "%@ tiene la sesión iniciada con una clave de API, que se deja como está.",
        switchUnavailable: "No se ha podido cambiar el inicio de sesión. No se ha modificado nada.",
        switchTargetMissing: "Ese inicio de sesión ya no está guardado.",
        saveFailedFormat: "No se ha podido guardar el inicio de sesión de %@.",
        removeFailed: "No se ha podido eliminar el inicio de sesión.",
        switchedFormat: "%1$@ ha cambiado a %2$@",
        previousAtFormat: "%1$@ al %2$@",
        exhaustedFormat: "Todos los inicios de sesión de %@ están cerca del límite",
        nextResetFormat: "Próximo reinicio %@",
        signedInFormat: "Sesión iniciada como %@",
        notSignedIn: "Sin sesión iniciada",
        apiKeyLogin: "Inicio de sesión con clave de API, no compatible",
        saveThisLogin: "Guardar este inicio de sesión",
        labelPlaceholder: "Etiqueta",
        remove: "Eliminar",
        removeConfirmFormat: "¿Eliminar %@?",
        removeHint: "Solo se borra la copia que guarda Vorssaint. El inicio de sesión en sí sigue activo.",
        autoSwapFormat: "Cambiar %@ automáticamente",
        autoSwapHint: "Cuando el inicio de sesión en uso se acerca a su límite, lo sustituye el guardado con más margen. También ocurre con la pantalla en reposo o el Mac bloqueado.",
        threshold: "Cambiar al",
        privacy: "Mientras esta sección está activada, Vorssaint envía el token de cada inicio de sesión de Claude guardado a api.anthropic.com para leer sus límites y lo renueva en platform.claude.com cuando caduca. Para un inicio de sesión de Codex, inicia la propia herramienta de Codex. Nada más sale de tu Mac. Los inicios de sesión se guardan en tu Llavero y en la carpeta privada de Vorssaint, y nunca forman parte de una copia de seguridad de los ajustes.",
        howTo: "Para añadir otra cuenta, inicia sesión en ella en un terminal con claude auth login o codex login. Vorssaint detecta el nuevo inicio de sesión y ofrece guardarlo. Los inicios de sesión guardados siguen siendo válidos."
    )

    static let sk = NotchAccountStrings(
        title: "Účty agentov",
        hubDescription: "Majte uložených viac prihlásení do Claude Code a Codexu, sledujte limity každého z nich a prepínajte medzi nimi v Dynamic Islande ťuknutím alebo automaticky.",
        settingsDescription: "Uchováva viac prihlásení do Claude Code a Codexu, zobrazuje limity každého z nich a prepína to, ktoré sa práve používa.",
        empty: "Zatiaľ nie sú uložené žiadne prihlásenia. Aktuálne prihlásenie uložte v Nastaveniach a pre ďalšie spustite v termináli claude auth login alebo codex login.",
        claudeSessionsFormat: "Spustené relácie: %@. Zmenu prevezmú do 30 s.",
        codexSessionsFormat: "Spustené relácie: %@. Po zmene ich reštartujte.",
        auto: "auto",
        active: "Aktívne",
        needsLogin: "Vyžaduje prihlásenie",
        needsLoginHint: "Platnosť tohto prihlásenia vypršala. Prihláste sa znova v termináli.",
        noUsage: "Zatiaľ žiadne využitie",
        switchToFormat: "Prepnúť na %@",
        unsavedFormat: "%@ je prihlásený a nie je uložený",
        save: "Uložiť",
        settings: "Nastavenia účtov agentov",
        usageRateLimited: "Príliš veľa požiadaviek. Limity sa načítajú znova neskôr.",
        usageToolMissingFormat: "%@ sa na tomto Macu nenašiel.",
        usageUnavailable: "Limity sa nepodarilo načítať.",
        switchBusyFormat: "%@ je zaneprázdnený. Skúste to o chvíľu znova.",
        switchUnsupportedFormat: "%@ je prihlásený kľúčom API, ktorý zostáva bez zmeny.",
        switchUnavailable: "Prihlásenie sa nepodarilo prepnúť. Nič sa nezmenilo.",
        switchTargetMissing: "Toto prihlásenie už nie je uložené.",
        saveFailedFormat: "Prihlásenie do %@ sa nepodarilo uložiť.",
        removeFailed: "Prihlásenie sa nepodarilo odstrániť.",
        switchedFormat: "%1$@: prepnuté na %2$@",
        previousAtFormat: "%1$@ na %2$@",
        exhaustedFormat: "Všetky prihlásenia do %@ sú blízko limitu",
        nextResetFormat: "Ďalšie obnovenie %@",
        signedInFormat: "Prihlásený ako %@",
        notSignedIn: "Neprihlásený",
        apiKeyLogin: "Prihlásenie kľúčom API, nepodporované",
        saveThisLogin: "Uložiť toto prihlásenie",
        labelPlaceholder: "Označenie",
        remove: "Odstrániť",
        removeConfirmFormat: "Odstrániť %@?",
        removeHint: "Vymaže sa iba kópia, ktorú uchováva Vorssaint. Samotné prihlásenie zostane aktívne.",
        autoSwapFormat: "Prepínať %@ automaticky",
        autoSwapHint: "Keď sa používané prihlásenie blíži k limitu, nahradí ho uložené prihlásenie s najväčšou rezervou. Deje sa to aj vtedy, keď je displej uspaný alebo Mac zamknutý.",
        threshold: "Prepnúť pri",
        privacy: "Kým je táto sekcia zapnutá, Vorssaint posiela token každého uloženého prihlásenia Claude na api.anthropic.com, aby načítal jeho limity, a po vypršaní ho obnovuje na platform.claude.com. Pre prihlásenie do Codexu spúšťa vlastný nástroj Codexu. Nič iné váš Mac neopúšťa. Prihlásenia zostávajú vo vašej Kľúčenke a v súkromnom priečinku Vorssaintu a nikdy nie sú súčasťou zálohy nastavení.",
        howTo: "Ak chcete pridať ďalší účet, prihláste sa doň v termináli príkazom claude auth login alebo codex login. Vorssaint si nové prihlásenie všimne a ponúkne jeho uloženie. Uložené prihlásenia zostávajú platné."
    )

    static let de = NotchAccountStrings(
        title: "Agenten-Accounts",
        hubDescription: "Mehrere Anmeldungen für Claude Code und Codex behalten, die Limits jeder einzelnen sehen und in der Dynamic Island zwischen ihnen wechseln, per Klick oder automatisch.",
        settingsDescription: "Behält mehrere Anmeldungen für Claude Code und Codex, zeigt die Limits jeder einzelnen und wechselt die verwendete.",
        empty: "Noch keine Anmeldungen gesichert. Sichere die aktuelle in den Einstellungen und führe für die nächste claude auth login oder codex login im Terminal aus.",
        claudeSessionsFormat: "Laufende Sitzungen: %@. Sie folgen einem Wechsel innerhalb von 30 s.",
        codexSessionsFormat: "Laufende Sitzungen: %@. Starte sie nach einem Wechsel neu.",
        auto: "auto",
        active: "Aktiv",
        needsLogin: "Anmeldung nötig",
        needsLoginHint: "Diese Anmeldung ist abgelaufen. Melde dich im Terminal erneut an.",
        noUsage: "Noch keine Nutzung",
        switchToFormat: "Zu %@ wechseln",
        unsavedFormat: "%@ ist angemeldet und nicht gesichert",
        save: "Sichern",
        settings: "Einstellungen für Agenten-Accounts",
        usageRateLimited: "Zu oft abgefragt. Die Limits werden später erneut gelesen.",
        usageToolMissingFormat: "%@ wurde auf diesem Mac nicht gefunden.",
        usageUnavailable: "Die Limits konnten nicht gelesen werden.",
        switchBusyFormat: "%@ ist beschäftigt. Versuche es gleich noch einmal.",
        switchUnsupportedFormat: "%@ ist mit einem API-Schlüssel angemeldet, der unverändert bleibt.",
        switchUnavailable: "Die Anmeldung konnte nicht gewechselt werden. Nichts wurde geändert.",
        switchTargetMissing: "Diese Anmeldung ist nicht mehr gesichert.",
        saveFailedFormat: "Die Anmeldung für %@ konnte nicht gesichert werden.",
        removeFailed: "Die Anmeldung konnte nicht entfernt werden.",
        switchedFormat: "%1$@ ist zu %2$@ gewechselt",
        previousAtFormat: "%1$@ bei %2$@",
        exhaustedFormat: "Alle Anmeldungen für %@ nahe am Limit",
        nextResetFormat: "Nächste Erneuerung %@",
        signedInFormat: "Angemeldet als %@",
        notSignedIn: "Nicht angemeldet",
        apiKeyLogin: "Anmeldung per API-Schlüssel, nicht unterstützt",
        saveThisLogin: "Diese Anmeldung sichern",
        labelPlaceholder: "Name",
        remove: "Entfernen",
        removeConfirmFormat: "%@ entfernen?",
        removeHint: "Nur die Kopie, die Vorssaint aufbewahrt, wird gelöscht. Die Anmeldung selbst bleibt bestehen.",
        autoSwapFormat: "%@ automatisch wechseln",
        autoSwapHint: "Nähert sich die verwendete Anmeldung ihrem Limit, übernimmt die gesicherte Anmeldung mit dem meisten Spielraum. Das geschieht auch, während der Bildschirm im Ruhezustand oder der Mac gesperrt ist.",
        threshold: "Wechseln bei",
        privacy: "Solange dieser Bereich aktiviert ist, sendet Vorssaint das Token jeder gesicherten Claude-Anmeldung an api.anthropic.com, um ihre Limits zu lesen, und erneuert es bei Ablauf über platform.claude.com. Für eine Codex-Anmeldung startet es das Codex-eigene Werkzeug. Sonst verlässt nichts deinen Mac. Anmeldungen bleiben in deinem Schlüsselbund und im privaten Ordner von Vorssaint und sind nie Teil eines Einstellungs-Backups.",
        howTo: "Um einen weiteren Account hinzuzufügen, melde dich im Terminal mit claude auth login oder codex login an. Vorssaint bemerkt die neue Anmeldung und bietet an, sie zu sichern. Gesicherte Anmeldungen bleiben gültig."
    )

    static let fr = NotchAccountStrings(
        title: "Comptes d’agents",
        hubDescription: "Conservez plusieurs connexions Claude Code et Codex, consultez les limites de chacune et passez de l’une à l’autre dans la Dynamic Island, d’un clic ou automatiquement.",
        settingsDescription: "Conserve plusieurs connexions Claude Code et Codex, affiche les limites de chacune et change celle qui est utilisée.",
        empty: "Aucune connexion enregistrée pour l’instant. Enregistrez celle que vous utilisez dans les Réglages, puis exécutez claude auth login ou codex login dans un terminal pour la suivante.",
        claudeSessionsFormat: "Sessions en cours\u{00A0}: %@. Elles suivent un changement en moins de 30 s.",
        codexSessionsFormat: "Sessions en cours\u{00A0}: %@. Redémarrez-les après un changement.",
        auto: "auto",
        active: "Active",
        needsLogin: "Connexion requise",
        needsLoginHint: "Cette connexion a expiré. Reconnectez-vous dans un terminal.",
        noUsage: "Aucune utilisation pour l’instant",
        switchToFormat: "Passer à %@",
        unsavedFormat: "%@ est connecté et n’est pas enregistré",
        save: "Enregistrer",
        settings: "Réglages des comptes d’agents",
        usageRateLimited: "Trop de demandes. Les limites seront relues plus tard.",
        usageToolMissingFormat: "%@ est introuvable sur ce Mac.",
        usageUnavailable: "Impossible de lire les limites.",
        switchBusyFormat: "%@ est occupé. Réessayez dans un instant.",
        switchUnsupportedFormat: "%@ est connecté avec une clé API, qui est laissée telle quelle.",
        switchUnavailable: "Impossible de changer de connexion. Rien n’a été modifié.",
        switchTargetMissing: "Cette connexion n’est plus enregistrée.",
        saveFailedFormat: "Impossible d’enregistrer la connexion %@.",
        removeFailed: "Impossible de supprimer la connexion.",
        switchedFormat: "%1$@ est passé à %2$@",
        previousAtFormat: "%1$@ à %2$@",
        exhaustedFormat: "Toutes les connexions %@ approchent de leur limite",
        nextResetFormat: "Prochaine réinitialisation %@",
        signedInFormat: "Connecté en tant que %@",
        notSignedIn: "Non connecté",
        apiKeyLogin: "Connexion par clé API, non prise en charge",
        saveThisLogin: "Enregistrer cette connexion",
        labelPlaceholder: "Libellé",
        remove: "Supprimer",
        removeConfirmFormat: "Supprimer %@\u{00A0}?",
        removeHint: "Seule la copie conservée par Vorssaint est supprimée. La connexion elle-même reste active.",
        autoSwapFormat: "Changer %@ automatiquement",
        autoSwapHint: "Quand la connexion utilisée approche de sa limite, la connexion enregistrée qui a le plus de marge prend le relais. Cela se produit aussi quand l’écran est en veille ou le Mac verrouillé.",
        threshold: "Changer à",
        privacy: "Tant que cette section est activée, Vorssaint envoie le jeton de chaque connexion Claude enregistrée à api.anthropic.com pour lire ses limites et le renouvelle sur platform.claude.com à son expiration. Pour une connexion Codex, il lance l’outil de Codex lui-même. Rien d’autre ne quitte votre Mac. Les connexions restent dans votre Trousseau et dans le dossier privé de Vorssaint, et ne font jamais partie d’une sauvegarde des réglages.",
        howTo: "Pour ajouter un autre compte, connectez-vous dans un terminal avec claude auth login ou codex login. Vorssaint remarque la nouvelle connexion et propose de l’enregistrer. Les connexions enregistrées restent valides."
    )

    static let it = NotchAccountStrings(
        title: "Account degli agenti",
        hubDescription: "Conserva più accessi a Claude Code e Codex, controlla i limiti di ciascuno e passa dall’uno all’altro nella Dynamic Island, con un clic o automaticamente.",
        settingsDescription: "Conserva più accessi a Claude Code e Codex, mostra i limiti di ciascuno e cambia quello in uso.",
        empty: "Nessun accesso salvato. Salva quello che usi ora nelle Impostazioni, poi esegui claude auth login o codex login in un terminale per il successivo.",
        claudeSessionsFormat: "Sessioni in esecuzione: %@. Seguono il cambio entro 30 s.",
        codexSessionsFormat: "Sessioni in esecuzione: %@. Riavviale dopo un cambio.",
        auto: "auto",
        active: "Attivo",
        needsLogin: "Accesso richiesto",
        needsLoginHint: "Questo accesso è scaduto. Accedi di nuovo in un terminale.",
        noUsage: "Ancora nessun utilizzo",
        switchToFormat: "Passa a %@",
        unsavedFormat: "%@ ha effettuato l’accesso e non è salvato",
        save: "Salva",
        settings: "Impostazioni degli account degli agenti",
        usageRateLimited: "Troppe richieste. I limiti verranno letti di nuovo più tardi.",
        usageToolMissingFormat: "%@ non è stato trovato su questo Mac.",
        usageUnavailable: "Impossibile leggere i limiti.",
        switchBusyFormat: "%@ è occupato. Riprova tra un attimo.",
        switchUnsupportedFormat: "%@ ha effettuato l’accesso con una chiave API, che resta invariata.",
        switchUnavailable: "Impossibile cambiare accesso. Non è stato modificato nulla.",
        switchTargetMissing: "Questo accesso non è più salvato.",
        saveFailedFormat: "Impossibile salvare l’accesso a %@.",
        removeFailed: "Impossibile rimuovere l’accesso.",
        switchedFormat: "%1$@ è passato a %2$@",
        previousAtFormat: "%1$@ al %2$@",
        exhaustedFormat: "Tutti gli accessi a %@ sono vicini al limite",
        nextResetFormat: "Prossimo ripristino %@",
        signedInFormat: "Accesso effettuato come %@",
        notSignedIn: "Accesso non effettuato",
        apiKeyLogin: "Accesso con chiave API, non supportato",
        saveThisLogin: "Salva questo accesso",
        labelPlaceholder: "Etichetta",
        remove: "Rimuovi",
        removeConfirmFormat: "Rimuovere %@?",
        removeHint: "Viene eliminata solo la copia conservata da Vorssaint. L’accesso in sé resta attivo.",
        autoSwapFormat: "Cambia %@ automaticamente",
        autoSwapHint: "Quando l’accesso in uso si avvicina al limite, subentra l’accesso salvato con più margine. Succede anche con lo schermo in stop o il Mac bloccato.",
        threshold: "Cambia al",
        privacy: "Finché questa sezione è attiva, Vorssaint invia il token di ogni accesso Claude salvato ad api.anthropic.com per leggerne i limiti e lo rinnova su platform.claude.com quando scade. Per un accesso Codex avvia lo strumento di Codex stesso. Nient’altro lascia il tuo Mac. Gli accessi restano nel tuo Portachiavi e nella cartella privata di Vorssaint e non fanno mai parte di un backup delle impostazioni.",
        howTo: "Per aggiungere un altro account, accedi in un terminale con claude auth login o codex login. Vorssaint nota il nuovo accesso e propone di salvarlo. Gli accessi salvati restano validi."
    )

    static let ru = NotchAccountStrings(
        title: "Учётные записи агентов",
        hubDescription: "Храните несколько входов в Claude Code и Codex, следите за лимитами каждого и переключайте их в Dynamic Island нажатием или автоматически.",
        settingsDescription: "Хранит несколько входов в Claude Code и Codex, показывает лимиты каждого и переключает используемый.",
        empty: "Сохранённых входов пока нет. Сохраните текущий в Настройках, а для следующего выполните в терминале claude auth login или codex login.",
        claudeSessionsFormat: "Запущено сеансов: %@. Они подхватят смену за 30 с.",
        codexSessionsFormat: "Запущено сеансов: %@. Перезапустите их после смены.",
        auto: "авто",
        active: "Активен",
        needsLogin: "Нужен вход",
        needsLoginHint: "Срок действия этого входа истёк. Войдите снова в терминале.",
        noUsage: "Данных об использовании пока нет",
        switchToFormat: "Переключить на %@",
        unsavedFormat: "%@: вход выполнен, но не сохранён",
        save: "Сохранить",
        settings: "Настройки учётных записей агентов",
        usageRateLimited: "Слишком много запросов. Лимиты будут прочитаны позже.",
        usageToolMissingFormat: "%@ не найден на этом Mac.",
        usageUnavailable: "Не удалось прочитать лимиты.",
        switchBusyFormat: "%@ сейчас занят. Повторите попытку через мгновение.",
        switchUnsupportedFormat: "%@ использует вход по ключу API, он оставлен без изменений.",
        switchUnavailable: "Не удалось переключить вход. Ничего не изменено.",
        switchTargetMissing: "Этот вход больше не сохранён.",
        saveFailedFormat: "Не удалось сохранить вход %@.",
        removeFailed: "Не удалось удалить вход.",
        switchedFormat: "%1$@: переключено на %2$@",
        previousAtFormat: "%1$@: %2$@",
        exhaustedFormat: "Все входы %@ близки к лимиту",
        nextResetFormat: "Следующий сброс %@",
        signedInFormat: "Выполнен вход как %@",
        notSignedIn: "Вход не выполнен",
        apiKeyLogin: "Вход по ключу API, не поддерживается",
        saveThisLogin: "Сохранить этот вход",
        labelPlaceholder: "Метка",
        remove: "Удалить",
        removeConfirmFormat: "Удалить %@?",
        removeHint: "Удаляется только копия, которую хранит Vorssaint. Сам вход остаётся активным.",
        autoSwapFormat: "Переключать %@ автоматически",
        autoSwapHint: "Когда используемый вход приближается к лимиту, его заменяет сохранённый вход с наибольшим запасом. Это происходит и тогда, когда дисплей в режиме сна или Mac заблокирован.",
        threshold: "Переключать при",
        privacy: "Пока этот раздел включён, Vorssaint отправляет токен каждого сохранённого входа Claude на api.anthropic.com, чтобы прочитать его лимиты, и обновляет его на platform.claude.com по истечении срока. Для входа Codex запускается собственный инструмент Codex. Больше ничего не покидает ваш Mac. Входы хранятся в Связке ключей и в личной папке Vorssaint и никогда не попадают в резервную копию настроек.",
        howTo: "Чтобы добавить ещё одну учётную запись, войдите в неё в терминале командой claude auth login или codex login. Vorssaint заметит новый вход и предложит сохранить его. Сохранённые входы остаются действительными."
    )

    static let tr = NotchAccountStrings(
        title: "Ajan Hesapları",
        hubDescription: "Birden fazla Claude Code ve Codex oturumunu saklayın, her birinin sınırlarını görün ve Dynamic Island’da dokunarak veya otomatik olarak aralarında geçiş yapın.",
        settingsDescription: "Claude Code ve Codex için birden fazla oturumu saklar, her birinin sınırlarını gösterir ve kullanılanı değiştirir.",
        empty: "Henüz kayıtlı oturum yok. Şu an kullandığınızı Ayarlar’da kaydedin, sonraki için terminalde claude auth login veya codex login komutunu çalıştırın.",
        claudeSessionsFormat: "Çalışan oturumlar: %@. Geçişi 30 sn içinde izlerler.",
        codexSessionsFormat: "Çalışan oturumlar: %@. Geçişten sonra yeniden başlatın.",
        auto: "oto",
        active: "Etkin",
        needsLogin: "Giriş gerekli",
        needsLoginHint: "Bu oturumun süresi doldu. Terminalde yeniden giriş yapın.",
        noUsage: "Henüz kullanım yok",
        switchToFormat: "%@ hesabına geç",
        unsavedFormat: "%@ giriş yapmış ve kaydedilmemiş",
        save: "Kaydet",
        settings: "Ajan Hesapları ayarları",
        usageRateLimited: "Çok sık soruldu. Sınırlar daha sonra yeniden okunacak.",
        usageToolMissingFormat: "%@ bu Mac’te bulunamadı.",
        usageUnavailable: "Sınırlar okunamadı.",
        switchBusyFormat: "%@ meşgul. Birazdan yeniden deneyin.",
        switchUnsupportedFormat: "%@ bir API anahtarıyla giriş yapmış, bu olduğu gibi bırakılır.",
        switchUnavailable: "Oturum değiştirilemedi. Hiçbir şey değişmedi.",
        switchTargetMissing: "Bu oturum artık kayıtlı değil.",
        saveFailedFormat: "%@ oturumu kaydedilemedi.",
        removeFailed: "Oturum kaldırılamadı.",
        switchedFormat: "%1$@, %2$@ hesabına geçti",
        previousAtFormat: "%1$@: %2$@",
        exhaustedFormat: "Tüm %@ oturumları sınıra yakın",
        nextResetFormat: "Sonraki sıfırlama %@",
        signedInFormat: "%@ olarak giriş yapıldı",
        notSignedIn: "Giriş yapılmadı",
        apiKeyLogin: "API anahtarıyla giriş, desteklenmiyor",
        saveThisLogin: "Bu oturumu kaydet",
        labelPlaceholder: "Etiket",
        remove: "Kaldır",
        removeConfirmFormat: "%@ kaldırılsın mı?",
        removeHint: "Yalnızca Vorssaint’in sakladığı kopya silinir. Oturumun kendisi açık kalır.",
        autoSwapFormat: "%@ için otomatik geçiş",
        autoSwapHint: "Kullanılan oturum sınırına yaklaştığında, en çok payı kalan kayıtlı oturum devralır. Bu, ekran uykudayken veya Mac kilitliyken de gerçekleşir.",
        threshold: "Geçiş eşiği",
        privacy: "Bu bölüm açıkken Vorssaint, sınırlarını okumak için kayıtlı her Claude oturumunun belirtecini api.anthropic.com adresine gönderir ve süresi dolduğunda platform.claude.com üzerinden yeniler. Codex oturumu için Codex’in kendi aracını başlatır. Başka hiçbir şey Mac’inizden çıkmaz. Oturumlar Anahtar Zinciri’nizde ve Vorssaint’in özel klasöründe kalır, hiçbir zaman ayar yedeğine girmez.",
        howTo: "Başka bir hesap eklemek için terminalde claude auth login veya codex login ile giriş yapın. Vorssaint yeni oturumu fark eder ve kaydetmeyi önerir. Kayıtlı oturumlar geçerli kalır."
    )

    static let ja = NotchAccountStrings(
        title: "エージェントアカウント",
        hubDescription: "Claude CodeとCodexの複数のログインを保持し、それぞれの上限を確認して、Dynamic Islandでタップまたは自動で切り替えます。",
        settingsDescription: "Claude CodeとCodexの複数のログインを保持し、それぞれの上限を表示して、使用中のログインを切り替えます。",
        empty: "保存済みのログインはまだありません。今使っているログインを設定で保存し、次のログインはターミナルでclaude auth loginまたはcodex loginを実行してください。",
        claudeSessionsFormat: "実行中のセッション: %@。30秒以内に切り替えに追従します。",
        codexSessionsFormat: "実行中のセッション: %@。切り替え後に再起動してください。",
        auto: "自動",
        active: "使用中",
        needsLogin: "ログインが必要",
        needsLoginHint: "このログインは期限切れです。ターミナルでもう一度ログインしてください。",
        noUsage: "使用量はまだありません",
        switchToFormat: "%@に切り替える",
        unsavedFormat: "%@はログイン中ですが保存されていません",
        save: "保存",
        settings: "エージェントアカウントの設定",
        usageRateLimited: "問い合わせが多すぎます。上限は後でもう一度読み取ります。",
        usageToolMissingFormat: "%@はこのMacに見つかりませんでした。",
        usageUnavailable: "上限を読み取れませんでした。",
        switchBusyFormat: "%@は使用中です。少ししてからもう一度お試しください。",
        switchUnsupportedFormat: "%@はAPIキーでログインしているため、そのままにします。",
        switchUnavailable: "ログインを切り替えられませんでした。何も変更されていません。",
        switchTargetMissing: "そのログインはもう保存されていません。",
        saveFailedFormat: "%@のログインを保存できませんでした。",
        removeFailed: "ログインを削除できませんでした。",
        switchedFormat: "%1$@を%2$@に切り替えました",
        previousAtFormat: "%1$@は%2$@",
        exhaustedFormat: "%@のすべてのログインが上限に近づいています",
        nextResetFormat: "次のリセットは%@",
        signedInFormat: "%@としてログイン中",
        notSignedIn: "ログインしていません",
        apiKeyLogin: "APIキーでのログインは非対応です",
        saveThisLogin: "このログインを保存",
        labelPlaceholder: "ラベル",
        remove: "削除",
        removeConfirmFormat: "%@を削除しますか？",
        removeHint: "削除されるのはVorssaintが保持するコピーだけです。ログイン自体はそのまま残ります。",
        autoSwapFormat: "%@を自動で切り替える",
        autoSwapHint: "使用中のログインが上限に近づくと、最も余裕のある保存済みログインに切り替わります。ディスプレイのスリープ中やMacのロック中にも行われます。",
        threshold: "切り替えるタイミング",
        privacy: "このセクションがオンの間、Vorssaintは保存済みの各Claudeログインのトークンをapi.anthropic.comに送信して上限を読み取り、期限が切れるとplatform.claude.comで更新します。Codexのログインでは、Codex自身のツールを起動します。それ以外は何もMacの外に出ません。ログインはキーチェーンとVorssaintの専用フォルダに保存され、設定のバックアップには含まれません。",
        howTo: "別のアカウントを追加するには、ターミナルでclaude auth loginまたはcodex loginを使ってログインします。Vorssaintが新しいログインを検出し、保存を提案します。保存済みのログインは有効なままです。"
    )

    static let ko = NotchAccountStrings(
        title: "에이전트 계정",
        hubDescription: "Claude Code와 Codex 로그인을 여러 개 보관하고, 각 로그인의 한도를 확인하며, Dynamic Island에서 탭하거나 자동으로 전환합니다.",
        settingsDescription: "Claude Code와 Codex 로그인을 여러 개 보관하고, 각 로그인의 한도를 보여 주며, 사용 중인 로그인을 전환합니다.",
        empty: "저장된 로그인이 아직 없습니다. 지금 사용하는 로그인을 설정에서 저장한 다음, 다음 로그인은 터미널에서 claude auth login 또는 codex login을 실행하세요.",
        claudeSessionsFormat: "실행 중인 세션: %@. 30초 안에 전환을 따릅니다.",
        codexSessionsFormat: "실행 중인 세션: %@. 전환 후 다시 시작하세요.",
        auto: "자동",
        active: "사용 중",
        needsLogin: "로그인 필요",
        needsLoginHint: "이 로그인은 만료되었습니다. 터미널에서 다시 로그인하세요.",
        noUsage: "아직 사용량 없음",
        switchToFormat: "%@(으)로 전환",
        unsavedFormat: "%@이(가) 로그인되어 있지만 저장되지 않았습니다",
        save: "저장",
        settings: "에이전트 계정 설정",
        usageRateLimited: "너무 자주 요청했습니다. 한도는 나중에 다시 읽습니다.",
        usageToolMissingFormat: "이 Mac에서 %@을(를) 찾을 수 없습니다.",
        usageUnavailable: "한도를 읽을 수 없습니다.",
        switchBusyFormat: "%@이(가) 사용 중입니다. 잠시 후 다시 시도하세요.",
        switchUnsupportedFormat: "%@은(는) API 키로 로그인되어 있어 그대로 둡니다.",
        switchUnavailable: "로그인을 전환할 수 없습니다. 변경된 것은 없습니다.",
        switchTargetMissing: "해당 로그인은 더 이상 저장되어 있지 않습니다.",
        saveFailedFormat: "%@ 로그인을 저장할 수 없습니다.",
        removeFailed: "로그인을 제거할 수 없습니다.",
        switchedFormat: "%1$@: %2$@(으)로 전환됨",
        previousAtFormat: "%1$@: %2$@",
        exhaustedFormat: "모든 %@ 로그인이 한도에 가까워졌습니다",
        nextResetFormat: "다음 재설정 %@",
        signedInFormat: "%@(으)로 로그인됨",
        notSignedIn: "로그인되지 않음",
        apiKeyLogin: "API 키 로그인, 지원되지 않음",
        saveThisLogin: "이 로그인 저장",
        labelPlaceholder: "레이블",
        remove: "제거",
        removeConfirmFormat: "%@을(를) 제거할까요?",
        removeHint: "Vorssaint가 보관하는 사본만 삭제됩니다. 로그인 자체는 그대로 유지됩니다.",
        autoSwapFormat: "%@ 자동 전환",
        autoSwapHint: "사용 중인 로그인이 한도에 가까워지면 여유가 가장 많은 저장된 로그인이 이어받습니다. 디스플레이가 잠자기 상태이거나 Mac이 잠겨 있을 때에도 이루어집니다.",
        threshold: "전환 시점",
        privacy: "이 섹션이 켜져 있는 동안 Vorssaint는 저장된 각 Claude 로그인의 토큰을 api.anthropic.com으로 보내 한도를 읽고, 만료되면 platform.claude.com에서 갱신합니다. Codex 로그인의 경우 Codex 자체 도구를 실행합니다. 그 밖에는 아무것도 Mac을 떠나지 않습니다. 로그인은 키체인과 Vorssaint의 비공개 폴더에 보관되며 설정 백업에는 포함되지 않습니다.",
        howTo: "다른 계정을 추가하려면 터미널에서 claude auth login 또는 codex login으로 로그인하세요. Vorssaint가 새 로그인을 감지하고 저장을 제안합니다. 저장된 로그인은 계속 유효합니다."
    )

    static let zhHans = NotchAccountStrings(
        title: "智能体账户",
        hubDescription: "保留多个 Claude Code 和 Codex 登录，查看各自的限额，并在 Dynamic Island 中轻点或自动切换。",
        settingsDescription: "保留多个 Claude Code 和 Codex 登录，显示各自的限额，并切换正在使用的登录。",
        empty: "尚未保存任何登录。请在设置中保存当前使用的登录，然后在终端中运行 claude auth login 或 codex login 以添加下一个。",
        claudeSessionsFormat: "正在运行的会话：%@。它们会在 30 秒内跟随切换。",
        codexSessionsFormat: "正在运行的会话：%@。切换后请重新启动。",
        auto: "自动",
        active: "使用中",
        needsLogin: "需要登录",
        needsLoginHint: "此登录已过期。请在终端中重新登录。",
        noUsage: "暂无用量",
        switchToFormat: "切换到 %@",
        unsavedFormat: "%@ 已登录但未保存",
        save: "保存",
        settings: "智能体账户设置",
        usageRateLimited: "请求过于频繁。稍后将再次读取限额。",
        usageToolMissingFormat: "在这台 Mac 上找不到 %@。",
        usageUnavailable: "无法读取限额。",
        switchBusyFormat: "%@ 正忙。请稍后重试。",
        switchUnsupportedFormat: "%@ 使用 API 密钥登录，将保持不变。",
        switchUnavailable: "无法切换登录。未做任何更改。",
        switchTargetMissing: "该登录已不再保存。",
        saveFailedFormat: "无法保存 %@ 登录。",
        removeFailed: "无法移除登录。",
        switchedFormat: "%1$@ 已切换到 %2$@",
        previousAtFormat: "%1$@ 已用 %2$@",
        exhaustedFormat: "所有 %@ 登录都接近限额",
        nextResetFormat: "下次重置 %@",
        signedInFormat: "已登录为 %@",
        notSignedIn: "未登录",
        apiKeyLogin: "API 密钥登录，不支持",
        saveThisLogin: "保存此登录",
        labelPlaceholder: "标签",
        remove: "移除",
        removeConfirmFormat: "移除 %@？",
        removeHint: "只会删除 Vorssaint 保留的副本。登录本身保持不变。",
        autoSwapFormat: "自动切换 %@",
        autoSwapHint: "当正在使用的登录接近限额时，由余量最多的已保存登录接替。显示器睡眠或 Mac 锁定时也会进行。",
        threshold: "切换时机",
        privacy: "此部分开启期间，Vorssaint 会将每个已保存 Claude 登录的令牌发送到 api.anthropic.com 以读取其限额，并在过期时通过 platform.claude.com 续期。对于 Codex 登录，它会启动 Codex 自己的工具。除此之外没有任何内容离开你的 Mac。登录保存在你的钥匙串和 Vorssaint 的私有文件夹中，绝不会包含在设置备份里。",
        howTo: "要添加另一个账户，请在终端中使用 claude auth login 或 codex login 登录。Vorssaint 会发现新的登录并提供保存。已保存的登录仍然有效。"
    )

    static let zhTW = NotchAccountStrings(
        title: "代理程式帳號",
        hubDescription: "保留多個 Claude Code 和 Codex 登入，查看各自的限額，並在 Dynamic Island 中點一下或自動切換。",
        settingsDescription: "保留多個 Claude Code 和 Codex 登入，顯示各自的限額，並切換正在使用的登入。",
        empty: "尚未儲存任何登入。請在設定中儲存目前使用的登入，然後在終端機中執行 claude auth login 或 codex login 以加入下一個。",
        claudeSessionsFormat: "執行中的工作階段：%@。它們會在 30 秒內跟隨切換。",
        codexSessionsFormat: "執行中的工作階段：%@。切換後請重新啟動。",
        auto: "自動",
        active: "使用中",
        needsLogin: "需要登入",
        needsLoginHint: "此登入已過期。請在終端機中重新登入。",
        noUsage: "尚無用量",
        switchToFormat: "切換到 %@",
        unsavedFormat: "%@ 已登入但尚未儲存",
        save: "儲存",
        settings: "代理程式帳號設定",
        usageRateLimited: "要求過於頻繁。稍後將再次讀取限額。",
        usageToolMissingFormat: "在這部 Mac 上找不到 %@。",
        usageUnavailable: "無法讀取限額。",
        switchBusyFormat: "%@ 忙碌中。請稍後再試。",
        switchUnsupportedFormat: "%@ 使用 API 金鑰登入，將維持不變。",
        switchUnavailable: "無法切換登入。未做任何更動。",
        switchTargetMissing: "該登入已不再儲存。",
        saveFailedFormat: "無法儲存 %@ 登入。",
        removeFailed: "無法移除登入。",
        switchedFormat: "%1$@ 已切換到 %2$@",
        previousAtFormat: "%1$@ 已用 %2$@",
        exhaustedFormat: "所有 %@ 登入都接近限額",
        nextResetFormat: "下次重置 %@",
        signedInFormat: "已登入為 %@",
        notSignedIn: "未登入",
        apiKeyLogin: "API 金鑰登入，不支援",
        saveThisLogin: "儲存此登入",
        labelPlaceholder: "標籤",
        remove: "移除",
        removeConfirmFormat: "移除 %@？",
        removeHint: "只會刪除 Vorssaint 保留的副本。登入本身維持不變。",
        autoSwapFormat: "自動切換 %@",
        autoSwapHint: "當使用中的登入接近限額時，由餘量最多的已儲存登入接手。顯示器睡眠或 Mac 鎖定時也會進行。",
        threshold: "切換時機",
        privacy: "此區段開啟期間，Vorssaint 會將每個已儲存 Claude 登入的權杖傳送到 api.anthropic.com 以讀取其限額，並在過期時透過 platform.claude.com 更新。對於 Codex 登入，它會啟動 Codex 自己的工具。除此之外沒有任何內容離開你的 Mac。登入儲存在你的鑰匙圈和 Vorssaint 的私人檔案夾中，絕不會包含在設定備份裡。",
        howTo: "若要加入另一個帳號，請在終端機中使用 claude auth login 或 codex login 登入。Vorssaint 會發現新的登入並提供儲存。已儲存的登入仍然有效。"
    )

    static let zhHK = NotchAccountStrings(
        title: "代理程式帳戶",
        hubDescription: "保留多個 Claude Code 和 Codex 登入，查看各自的限額，並在 Dynamic Island 中點一下或自動切換。",
        settingsDescription: "保留多個 Claude Code 和 Codex 登入，顯示各自的限額，並切換正在使用的登入。",
        empty: "尚未儲存任何登入。請在設定中儲存目前使用的登入，然後在終端機中執行 claude auth login 或 codex login 以加入下一個。",
        claudeSessionsFormat: "執行中的工作階段：%@。它們會在 30 秒內跟隨切換。",
        codexSessionsFormat: "執行中的工作階段：%@。切換後請重新啟動。",
        auto: "自動",
        active: "使用中",
        needsLogin: "需要登入",
        needsLoginHint: "此登入已過期。請在終端機中重新登入。",
        noUsage: "尚無用量",
        switchToFormat: "切換至 %@",
        unsavedFormat: "%@ 已登入但尚未儲存",
        save: "儲存",
        settings: "代理程式帳戶設定",
        usageRateLimited: "要求過於頻繁。稍後將再次讀取限額。",
        usageToolMissingFormat: "在這部 Mac 上找不到 %@。",
        usageUnavailable: "無法讀取限額。",
        switchBusyFormat: "%@ 忙碌中。請稍後再試。",
        switchUnsupportedFormat: "%@ 使用 API 密鑰登入，將維持不變。",
        switchUnavailable: "無法切換登入。未作任何更改。",
        switchTargetMissing: "該登入已不再儲存。",
        saveFailedFormat: "無法儲存 %@ 登入。",
        removeFailed: "無法移除登入。",
        switchedFormat: "%1$@ 已切換至 %2$@",
        previousAtFormat: "%1$@ 已用 %2$@",
        exhaustedFormat: "所有 %@ 登入都接近限額",
        nextResetFormat: "下次重設 %@",
        signedInFormat: "已登入為 %@",
        notSignedIn: "未登入",
        apiKeyLogin: "API 密鑰登入，不支援",
        saveThisLogin: "儲存此登入",
        labelPlaceholder: "標籤",
        remove: "移除",
        removeConfirmFormat: "移除 %@？",
        removeHint: "只會刪除 Vorssaint 保留的副本。登入本身維持不變。",
        autoSwapFormat: "自動切換 %@",
        autoSwapHint: "當使用中的登入接近限額時，由餘量最多的已儲存登入接手。顯示器睡眠或 Mac 鎖定時也會進行。",
        threshold: "切換時機",
        privacy: "此部分開啟期間，Vorssaint 會將每個已儲存 Claude 登入的權杖傳送至 api.anthropic.com 以讀取其限額，並在過期時透過 platform.claude.com 更新。對於 Codex 登入，它會啟動 Codex 自己的工具。除此之外沒有任何內容離開你的 Mac。登入儲存在你的鑰匙圈和 Vorssaint 的私人資料夾中，絕不會包含在設定備份內。",
        howTo: "如要加入另一個帳戶，請在終端機中使用 claude auth login 或 codex login 登入。Vorssaint 會發現新的登入並提供儲存。已儲存的登入仍然有效。"
    )
}
