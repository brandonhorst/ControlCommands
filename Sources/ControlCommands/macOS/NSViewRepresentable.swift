#if canImport(AppKit)
import AppKit
import SwiftUI

internal class ControlCommandNSView: NSView {
    var controlCommands: [ControlCommand]!
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        for command in controlCommands where command.key.isEquivalentTo(keyEvent: event) {
            return true
        }
        return super.performKeyEquivalent(with: event)
    }
}

internal struct ControlCommandWrapperView<Content: View>: NSViewRepresentable {
    private let view = ControlCommandNSView(frame: .zero)
    private var content: NSView

    init(ControlCommands: [ControlCommand], @ViewBuilder content: () -> Content) {
        view.controlCommands = ControlCommands

        self.content = NSHostingController(rootView: content()).view
        self.content.translatesAutoresizingMaskIntoConstraints = false
    }

    func makeNSView(context: Context) -> some NSView {
        return view
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {
        content.removeFromSuperview()
        view.addSubview(content)
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            content.topAnchor.constraint(equalTo: view.topAnchor),
            content.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

internal extension KeyboardShortcut {
    func isEquivalentTo(keyEvent: NSEvent) -> Bool {
        guard self.modifiers.isEquivalentTo(modifierFlags: keyEvent.modifierFlags) else {
            return false
        }
        if let characters = keyEvent.charactersIgnoringModifiers {
            return self.key.isEquivalentTo(characters: characters)
        } else {
            return self.key.isEquivalentTo(keyCode: keyEvent.keyCode)
        }
    }
}

internal extension KeyEquivalent {
    func isEquivalentTo(characters: String) -> Bool {
        return false
//        switch self.character {
//        case KeyEquivalent.upArrow.character: return Key
//        case KeyEquivalent.downArrow.character: return UIKeyCommand.inputDownArrow
//        case KeyEquivalent.leftArrow.character: return UIKeyCommand.inputLeftArrow
//        case KeyEquivalent.clear.character: return UIKeyCommand.inputRightArrow
//        case KeyEquivalent.deleteForward.character: return "\u{7f}"
//        case KeyEquivalent.end.character: return UIKeyCommand.inputEnd
//        case KeyEquivalent.escape.character: return UIKeyCommand.inputEscape
//        case KeyEquivalent.delete.character: return UIKeyCommand.inputDelete
//        case KeyEquivalent.home.character: return UIKeyCommand.inputHome
//        case KeyEquivalent.pageUp.character: return UIKeyCommand.inputPageUp
//        case KeyEquivalent.pageDown.character: return UIKeyCommand.inputPageDown
//        case KeyEquivalent.`return`.character: return "\r"
//        case KeyEquivalent.space.character: return " "
//        case KeyEquivalent.tab.character: return "\t"
//        default: return String(self.character)
//        }
    }
    func isEquivalentTo(keyCode: UInt16) -> Bool {
        return false
    }

}

internal extension EventModifiers {
    func isEquivalentTo(modifierFlags: NSEvent.ModifierFlags) -> Bool {
        return false
    }
//    func toKeyModifierFlags() -> UIKeyModifierFlags {
//        var result = UIKeyModifierFlags()
//        if self.contains(.command) { result.insert(.command) }
//        if self.contains(.shift) { result.insert(.shift) }
//        if self.contains(.option) { result.insert(.alternate) }
//        if self.contains(.control) { result.insert(.control) }
//        if self.contains(.numericPad) { result.insert(.numericPad) }
//        if self.contains(.capsLock) { result.insert(.alphaShift) }
//        if self.contains(.all) {
//            result.insert(.command)
//            result.insert(.shift)
//            result.insert(.alternate)
//            result.insert(.control)
//            result.insert(.numericPad)
//            result.insert(.alphaShift)
//        }
//        return result
//    }
}
#endif
