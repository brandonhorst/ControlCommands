import XCTest

final class TestAppUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testNoModifier() throws {
        let app = XCUIApplication()
        app.launch()
        app.textFields.element.tap()
        app.typeKey(XCUIKeyboardKey.downArrow.rawValue, modifierFlags: [])
        app.assertResult("down")
    }

    func testCommand() throws {
        let app = XCUIApplication()
        app.launch()
        app.textFields.element.tap()
        app.typeKey("j", modifierFlags: .command)
        app.assertResult("cmd+j")
    }

    func testCommandControlOptionShift() throws {
        let app = XCUIApplication()
        app.launch()
        app.textFields.element.tap()
        app.typeKey("8", modifierFlags: [.command, .control, .option, .shift])
        app.assertResult("cmd+ctrl+opt+shift+8")
    }
}

extension XCUIElement {
    func assertResult(_ string: String) {
        #if os(macOS)
        XCTAssertEqual(staticTexts["Result"].value as! String, string)
        #else
        XCTAssertEqual(staticTexts["Result"].label, string)
        #endif
    }
}
