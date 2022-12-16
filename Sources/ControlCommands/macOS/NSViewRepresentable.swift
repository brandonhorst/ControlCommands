#if os(macOS)
import AppKit
import Carbon.HIToolbox
import SwiftUI

internal class ControlCommandNSView: NSView {
    var controlCommands: [ControlCommand]!
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        for command in self.controlCommands where command.key.isEquivalentTo(keyEvent: event) {
            command.action()
            return true
        }
        return super.performKeyEquivalent(with: event)
    }
}

internal struct ControlCommandWrapperView<Content: View>: NSViewRepresentable {
    private let view = ControlCommandNSView(frame: .zero)
    private var content: NSView

    init(ControlCommands: [ControlCommand], @ViewBuilder content: () -> Content) {
        self.view.controlCommands = ControlCommands

        self.content = NSHostingController(rootView: content()).view
        self.content.translatesAutoresizingMaskIntoConstraints = false
    }

    func makeNSView(context: Context) -> some NSView {
        return self.view
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {
        self.content.removeFromSuperview()
        self.view.addSubview(self.content)
        NSLayoutConstraint.activate([
            self.content.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.content.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.content.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.content.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
}

internal extension KeyboardShortcut {
    func isEquivalentTo(keyEvent: NSEvent) -> Bool {
        guard self.modifiers.isEquivalentTo(modifierFlags: keyEvent.modifierFlags) else {
            return false
        }
        return self.key.isEquivalentTo(keyCode: keyEvent.keyCode) || self.key.isEquivalentTo(characters: keyEvent.characters ?? "")
    }
}

internal extension KeyEquivalent {
    func isEquivalentTo(characters: String) -> Bool {
        return String(self.character) == characters
    }

    func isEquivalentTo(keyCode: UInt16) -> Bool {
        switch self.character {
        case KeyEquivalent.upArrow.character: return keyCode == kVK_UpArrow
        case KeyEquivalent.downArrow.character: return keyCode == kVK_DownArrow
        case KeyEquivalent.leftArrow.character: return keyCode == kVK_LeftArrow
        case KeyEquivalent.clear.character: return keyCode == kVK_ANSI_KeypadClear
        case KeyEquivalent.deleteForward.character: return keyCode == kVK_ForwardDelete
        case KeyEquivalent.end.character: return keyCode == kVK_End
        case KeyEquivalent.escape.character: return keyCode == kVK_Escape
        case KeyEquivalent.delete.character: return keyCode == kVK_Delete
        case KeyEquivalent.home.character: return keyCode == kVK_Home
        case KeyEquivalent.pageUp.character: return keyCode == kVK_PageUp
        case KeyEquivalent.pageDown.character: return keyCode == kVK_PageDown
        case KeyEquivalent.return.character: return keyCode == kVK_Return
        case KeyEquivalent.space.character: return keyCode == kVK_Space
        case KeyEquivalent.tab.character: return keyCode == kVK_Tab
        default: return false
        }
    }
}

internal extension SwiftUI.EventModifiers {
    func isEquivalentTo(modifierFlags: NSEvent.ModifierFlags) -> Bool {
        let all = contains(.all)
        return (all || contains(.command)) == modifierFlags.contains(.command) &&
            (all || contains(.shift)) == modifierFlags.contains(.shift) &&
            (all || contains(.option)) == modifierFlags.contains(.option) &&
            (all || contains(.control)) == modifierFlags.contains(.control) &&
            (all || contains(.capsLock)) == modifierFlags.contains(.capsLock)
    }
}
#endif
