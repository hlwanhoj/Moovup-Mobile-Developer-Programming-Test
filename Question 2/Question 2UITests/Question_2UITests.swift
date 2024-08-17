//
//  Question_2UITests.swift
//  Question 2UITests
//
//  Created by hlwan on 17/8/2024.
//

import XCTest
//import SnapshotTesting

final class Question_2UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testUserListToDetail() async throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments.append("-disableAnimations")
        app.launch()
        
        await XCTWaiter().fulfillment(of: [XCTestExpectation()], timeout: 2)
        // Not sure why first tap is not working
        app.staticTexts["Valentine Diaz"].tap()
        app.staticTexts["Valentine Diaz"].tap()

        let isTitleExists = app.staticTexts["user-detail-user-title"].exists
        let isEmailExists = app.staticTexts["user-detail-user-email"].exists
        XCTAssert(isTitleExists)
        XCTAssert(isEmailExists)
        
        app.navigationBars["Question_2.UserDetailView"].buttons["Users"].tap()
        let isCellExists = app.staticTexts["Valentine Diaz"].exists
        XCTAssert(isCellExists)
    }
    
    @MainActor
    func testUserListToMap() async throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments.append("-disableAnimations")
        app.launch()
        
        // Wait for API result
        await XCTWaiter().fulfillment(of: [XCTestExpectation()], timeout: 5)
        app.tabBars["Tab Bar"].buttons["Map View"].tap()
        
        let isMarkerExist = app.otherElements["Valentine Diaz"].exists
        XCTAssert(isMarkerExist)
        
        app.otherElements["Valentine Diaz"].tap()
    }
}
