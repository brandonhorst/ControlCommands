import SwiftUI

public struct ControlCommand {
    public init(title: String, key: KeyboardShortcut, action: @escaping () -> Void) {
        self.title = title
        self.key = key
        self.action = action
    }
    
    let title: String
    let key: KeyboardShortcut
    let action: () -> Void
}

public protocol ControlCommands {
    @ControlCommandsBuilder var body: [ControlCommand] { get }
}

public struct ControlCommandList : ControlCommands {
    public init(@ControlCommandsBuilder commands: @escaping () -> [ControlCommand]) {
        self.commands = commands
    }
    
    @ControlCommandsBuilder var commands: () -> [ControlCommand]
    public var body: [ControlCommand] {
        return commands()
    }
}
