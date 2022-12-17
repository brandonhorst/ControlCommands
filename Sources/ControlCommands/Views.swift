import SwiftUI

public extension View {
    func controlCommands(_ content: @escaping () -> ControlCommands) -> some View {
        modifier(ControlCommandViewModifier(controlCommands: content))
    }
}

internal struct ControlCommandViewModifier: ViewModifier {
    var controlCommands: () -> ControlCommands
    
    func body(content: Content) -> some View {
        ControlCommandWrapperView(controlCommands: controlCommands().body) {
            content
        }
    }
}
