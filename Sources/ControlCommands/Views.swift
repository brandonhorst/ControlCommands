import SwiftUI

public extension View {
    func controlCommands(_ content: @escaping () -> ControlCommands) -> some View {
        modifier(ControlCommandViewModifier(ControlCommands: content))
    }
}

internal struct ControlCommandViewModifier: ViewModifier {
    var ControlCommands: () -> ControlCommands
    
    func body(content: Content) -> some View {
        ControlCommandWrapperView(ControlCommands: ControlCommands().body) {
            content
        }
    }
}
