import SwiftUI

@testable import ControlCommands
import XCTest

final class ControlCommandsTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()

        continueAfterFailure = false
    }

    func testReadmeExampleControlCommandListCompiles() throws {
        struct CommandLine {
            @State var text = ""
            @State var areVimControlsEnabled = false

            func moveUp() { print("move up") }
            func moveDown() { print("move up") }

            var body: some View {
                TextField("", text: $text)
                    .controlCommands {
                        ControlCommandList {
                            ControlCommand(title: "Previous", key: KeyboardShortcut(.upArrow, modifiers: []), action: moveUp)
                            ControlCommand(title: "Next", key: KeyboardShortcut(.downArrow, modifiers: []), action: moveDown)
                            if areVimControlsEnabled {
                                ControlCommand(title: "Previous (Vim)", key: KeyboardShortcut("k"), action: moveUp)
                                ControlCommand(title: "Next (Vim)", key: KeyboardShortcut("j"), action: moveDown)
                            }
                            ControlCommand(title: "Enable Vim Controls", key: KeyboardShortcut("v", modifiers: [.command, .shift])) {
                                areVimControlsEnabled = true
                            }
                        }
                    }
            }
        }
        let _ = CommandLine()
    }

    func testReadmeExampleControlCommandsCompiles() throws {
        struct MovementCommands: ControlCommands {
            var move: (Int) -> Void

            var body: [ControlCommand] {
                ControlCommand(title: "Previous", key: KeyboardShortcut(.upArrow, modifiers: [])) {
                    move(-1)
                }
                ControlCommand(title: "Next", key: KeyboardShortcut(.downArrow, modifiers: [])) {
                    move(1)
                }
            }
        }

        struct CommandLine {
            @State var text = ""
            @State var enableVimControls = false

            func move(offset: Int) {
                print("move \(offset)")
            }

            var body: some View {
                TextField("", text: $text)
                    .controlCommands { MovementCommands(move: move) }
            }
        }

        let _ = CommandLine()
    }
}
