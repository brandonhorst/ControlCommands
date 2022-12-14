import SwiftUI

@resultBuilder
public enum ControlCommandsBuilder {
    public static func buildEither(first component: [ControlCommand]) -> [ControlCommand] {
        component
    }
    
    public   static func buildEither(second component: [ControlCommand]) -> [ControlCommand] {
        component
    }
    
    public static func buildOptional(_ component: [ControlCommand]?) -> [ControlCommand] {
        component ?? []
    }
    
    public static func buildBlock(_ components: [ControlCommand]...) -> [ControlCommand] {
        components.flatMap { $0 }
    }
    
    public  static func buildExpression(_ expression: ControlCommand) -> [ControlCommand] {
        [expression]
    }
    
    public static func buildArray(_ components: [[ControlCommand]]) -> [ControlCommand] {
        return components.flatMap { $0 }
    }
    
    public static func buildLimitedAvailability(_ component: [ControlCommand]) -> [ControlCommand] {
        return component
    }
}
