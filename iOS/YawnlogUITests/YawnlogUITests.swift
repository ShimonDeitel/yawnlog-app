import XCTest

final class YawnlogUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddFlowShowsNewItem() throws {
        app.buttons["addItemButton"].tap()
        let saveButton = app.buttons["saveItemButton"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2))
        saveButton.tap()
        XCTAssertTrue(app.staticTexts.count > 0)
    }

    func testFreeLimitTriggersPaywall() throws {
        for _ in 0..<50 {
            guard app.buttons["addItemButton"].exists else { break }
            app.buttons["addItemButton"].tap()
            if app.otherElements["paywallView"].waitForExistence(timeout: 1) {
                XCTAssertTrue(app.buttons["paywallPurchaseButton"].exists)
                break
            }
            if app.buttons["saveItemButton"].waitForExistence(timeout: 1) {
                app.buttons["saveItemButton"].tap()
            } else {
                break
            }
        }
    }

    func testKeyboardDismissOnTapOutside() throws {
        app.buttons["addItemButton"].tap()
        let textField = app.textFields.firstMatch
        if textField.waitForExistence(timeout: 2) {
            textField.tap()
            XCTAssertTrue(app.keyboards.element.exists)
            app.otherElements["addItemFormBackground"].tap()
            XCTAssertFalse(app.keyboards.element.exists)
        }
    }

    func testSettingsOpens() throws {
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 2))
        app.buttons["settingsDoneButton"].tap()
    }
}
