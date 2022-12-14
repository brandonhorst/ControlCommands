import SwiftUI
import XCTest
@testable import ControlCommands

final class ControlCommandsTests: XCTestCase {
    func testControlCommandList() throws {
        let _ = TextField("", text: .constant(""))
            .controlCommands {
                ControlCommandList {
                    ControlCommand(title: "a", key: KeyboardShortcut("a")) { print("a") }
                    ControlCommand(title: "b", key: KeyboardShortcut("b")) { print("b") }
                }
            }
    }
    
    func testCustomControlCommands() throws {
        struct TestControlCommands: ControlCommands {
            var body: [ControlCommand] {
            ControlCommand(title: "a", key: KeyboardShortcut("a")) { print("a") }
            ControlCommand(title: "b", key: KeyboardShortcut("b")) { print("b") }
            }
        }
        let _ = TextField("", text: .constant(""))
            .controlCommands { TestControlCommands() }
    }
}
