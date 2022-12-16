# `ControlCommands`

## Introduction

A Swift Package for adding keyboard commands to SwiftUI Controls. Supports macOS and iOS devices with an external keyboard.

SwiftUI has a few means of enabling keyboard access.

- `Scene.commands()` allows you to create global keyboard shortcuts and menu items that apply to the entire `Scene`. They allow you to provide a custom `action` to execute your own code.
- `View.keyboardShortcut()` allows you to create local keyboard shortcuts that activate particular elements. They do not allow you to execute your own code.

`ControlCommands` enable you to create local keyboard shortcuts that are only functional when a certain control is focused.

These keyboard shortcuts do not need to pollute the global menu. They supercede any global keyboard shortcuts when active.

For example, when a `TextField` is focused, enable the ↑ and ↓ arrow keys to change the selection of a search results `List`.

It uses a `ControlCommandsBuilder` `resultBuilder` modeled after SwiftUI, enabling commands to be set up declaratively.

## Installation

Add this Swift Package:

```
http://github.com/brandonhorst/ControlCommands
```

## Usage

Use `View.controlCommands` and `ControlCommandsList` to define your command.

```swift
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
```

To reuse the same `ControlCommands` for multiple controls, you can define your own struct which conforms to `ControlCommands`.

```swift
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
```

## Running Tests

Because the majority of this library runs at the intersection of SwiftUI and AppKit/UIKit, it's tested using XCode UI Tests in the included `TestApp`.

These tests can be run on Mac and Mac Catalyst because iOS and iPadOS do not support the `XCUIElement.typeKey` function (even though the docs say iPadOS should). The TestApp can be tested manually in the simulator.

You can run the tests with

```sh
xcodebuild -project TestApp/TestApp.xcodeproj -scheme TestApp \
 -destination 'platform=macOS,arch=arm64' clean test
 
xcodebuild -project TestApp/TestApp.xcodeproj -scheme TestApp \
 -destination 'platform=macOS,arch=x86_64' clean test
 
xcodebuild -project TestApp/TestApp.xcodeproj -scheme TestApp \
 -destination 'platform=macOS,variant=Mac Catalyst,arch=arm64' test
 
xcodebuild -project TestApp/TestApp.xcodeproj -scheme TestApp \
 -destination 'platform=macOS,variant=Mac Catalyst,arch=x86_64' test
```
