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

    func testExample() async throws {
        // UI tests must launch the application that they test.
        let app = await XCUIApplication()
        await app.launch()

//        await XCTWaiter().fulfillment(of: [XCTestExpectation()], timeout: 3)
//        let a = await app.screenshot()
//        let tabBarControllerImage = await a.image
//        
//
//        assertSnapshot(of: tabBarControllerImage, as: .image)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
