//
//  ContentView.swift
//  ControlCommandsDemo
//
//  Created by Brandon Horst on 12/14/22.
//

import SwiftUI
import ControlCommands

struct ContentView: View {
    @State var result = ""
    @State var textField = ""
    @FocusState var focus: Bool
    
    var body: some View {
        VStack {
            TextField("text", text: $textField)
                .border(.red)
                .controlCommands {
                    ControlCommandList {
                        ControlCommand(title: "", key: KeyboardShortcut(.downArrow, modifiers: [])) {
                            result = "down"
                        }
                        ControlCommand(title: "", key: KeyboardShortcut("j")) {
                            result = "cmd+j"
                        }
                        ControlCommand(title: "", key: KeyboardShortcut("8", modifiers: [.command, .control, .option, .shift])) {
                            result = "cmd+ctrl+opt+shift+8"
                        }
                    }
                }
            Text(result)
                .accessibilityIdentifier("Result")
        }
        .padding()
        .frame(width: 300, height: 200)
        .border(.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
