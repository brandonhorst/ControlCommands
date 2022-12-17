#if os(iOS)
import UIKit
import SwiftUI

internal class ControlCommandUIView: UIView {
    var controlCommands: [ControlCommand]!
    
    @objc func executeCommand(sender: UIKeyCommand) {
        if let index = sender.propertyList as? Int {
            controlCommands[index].action()
        }
    }

    override var keyCommands: [UIKeyCommand]? {
        return controlCommands.enumerated().compactMap {index, command in
            guard let input = command.key.key.toKeyCommandCharacter() else {
                return nil
            }
            let keyCommand = UIKeyCommand(title: command.title, action: #selector(executeCommand(sender:)), input: input, modifierFlags: command.key.modifiers.toKeyModifierFlags(), propertyList: index)
            keyCommand.wantsPriorityOverSystemBehavior = true
            return keyCommand
        }
    }
}

internal struct ControlCommandWrapperView<Content: View>: UIViewRepresentable {
    private let view = ControlCommandUIView(frame: .zero)
    private var content: UIView
    
    init(controlCommands: [ControlCommand], @ViewBuilder content: () -> Content) {
        view.controlCommands = controlCommands
        
        self.content = UIHostingController(rootView: content()).view
        self.content.translatesAutoresizingMaskIntoConstraints = false
        self.content.backgroundColor = .clear
    }
    
    func makeUIView(context: Context) -> some UIView {
        return view
    }
    
    func updateUIView(_ uiView: some UIView, context: Context) {
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

internal extension KeyEquivalent {
    func toKeyCommandCharacter() -> String? {
        switch self.character {
        case KeyEquivalent.upArrow.character: return UIKeyCommand.inputUpArrow
        case KeyEquivalent.downArrow.character: return UIKeyCommand.inputDownArrow
        case KeyEquivalent.leftArrow.character: return UIKeyCommand.inputLeftArrow
        case KeyEquivalent.clear.character: return UIKeyCommand.inputRightArrow
        case KeyEquivalent.deleteForward.character: return "\u{7f}"
        case KeyEquivalent.end.character: return UIKeyCommand.inputEnd
        case KeyEquivalent.escape.character: return UIKeyCommand.inputEscape
        case KeyEquivalent.delete.character: return UIKeyCommand.inputDelete
        case KeyEquivalent.home.character: return UIKeyCommand.inputHome
        case KeyEquivalent.pageUp.character: return UIKeyCommand.inputPageUp
        case KeyEquivalent.pageDown.character: return UIKeyCommand.inputPageDown
        case KeyEquivalent.`return`.character: return "\r"
        case KeyEquivalent.space.character: return " "
        case KeyEquivalent.tab.character: return "\t"
        default: return String(self.character)
        }
    }
}

internal extension EventModifiers {
    func toKeyModifierFlags() -> UIKeyModifierFlags {
        var result = UIKeyModifierFlags()
        if self.contains(.command) { result.insert(.command) }
        if self.contains(.shift) { result.insert(.shift) }
        if self.contains(.option) { result.insert(.alternate) }
        if self.contains(.control) { result.insert(.control) }
        if self.contains(.numericPad) { result.insert(.numericPad) }
        if self.contains(.capsLock) { result.insert(.alphaShift) }
        if self.contains(.all) {
            result.insert(.command)
            result.insert(.shift)
            result.insert(.alternate)
            result.insert(.control)
            result.insert(.numericPad)
            result.insert(.alphaShift)
        }
        return result
    }
}
#endif
