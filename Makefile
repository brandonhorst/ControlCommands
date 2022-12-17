SHELL=/bin/bash -o pipefail

test: test_functional test_ui

test_functional: test_mac test_catalyst test_ipad test_iphone

test_ui: test_mac_ui test_catalyst_ui

clean:
	xcodebuild clean

test_mac:
	xcodebuild test -scheme ControlCommands -destination 'platform=macOS' | xcpretty
test_catalyst:
	xcodebuild test -scheme ControlCommands -destination 'platform=macOS,variant=Mac Catalyst' | xcpretty
test_ipad:
	xcodebuild test -scheme ControlCommands -destination 'platform=iOS Simulator,name=iPad (10th generation)' | xcpretty
test_iphone:
	xcodebuild test -scheme ControlCommands -destination 'platform=iOS Simulator,name=iPhone 14' | xcpretty

test_mac_ui:
	xcodebuild test -project TestApp/TestApp.xcodeproj -scheme TestApp -destination 'platform=macOS' | xcpretty
test_catalyst_ui:
	xcodebuild test -project TestApp/TestApp.xcodeproj -scheme TestApp -destination 'platform=macOS,variant=Mac Catalyst' | xcpretty
