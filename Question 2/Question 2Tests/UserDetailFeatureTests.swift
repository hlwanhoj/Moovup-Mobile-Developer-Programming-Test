//
//  UserDetailFeatureTests.swift
//  Question 2Tests
//
//  Created by hlwan on 17/8/2024.
//

import XCTest
import ComposableArchitecture
import SnapshotTesting
import API
@testable import Question_2

final class UserDetailFeatureTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test() throws {
        let store = TestStore(
            initialState: UserDetailFeature.State(
                user: User(
                    id: "0003",
                    name: User.Name(first: "Alexander Benjamin Theodore Montgomery III", last: nil),
                    email: "abc@abc.com",
                    pictureUrlString: "https://placebear.com/800/400",
                    location: User.Location(latitude: 22.39, longitude: 114.08)
                )
            ),
            reducer: {
                UserDetailFeature()
            }
        )
        store.exhaustivity = .off
    }
    
    // MARK: - UI Snapshots

    @MainActor
    func testUserDetailVC() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let navVC = UINavigationController(
            rootViewController: UserDetailViewController(
                store: Store(
                    initialState: UserDetailFeature.State(
                        user: User(
                            id: "0003",
                            name: User.Name(first: "Alexander Benjamin Theodore Montgomery III", last: nil),
                            email: "abc@abc.com",
                            pictureUrlString: "https://placebear.com/800/400",
                            location: User.Location(latitude: 22.39, longitude: 114.08)
                        )
                    ),
                    reducer: {
                        UserDetailFeature()
                    }
                )
            )
        )
        navVC.loadViewIfNeeded()
        navVC.view.setNeedsLayout()
        navVC.view.layoutIfNeeded()

        await XCTWaiter().fulfillment(of: [XCTestExpectation()], timeout: 3)
        assertSnapshot(of: navVC, as: .image)
    }

    @MainActor
    func testUserDetailVCWithNoLocation() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let navVC = UINavigationController(
            rootViewController: UserDetailViewController(
                store: Store(
                    initialState: UserDetailFeature.State(
                        user: User(
                            id: "0003",
                            name: User.Name(first: "Alexander Benjamin Theodore Montgomery III", last: nil),
                            email: "abc@abc.com",
                            pictureUrlString: "https://placebear.com/800/400",
                            location: User.Location(latitude: 22.39, longitude: nil)
                        )
                    ),
                    reducer: {
                        UserDetailFeature()
                    }
                )
            )
        )
        navVC.loadViewIfNeeded()
        navVC.view.setNeedsLayout()
        navVC.view.layoutIfNeeded()

        await XCTWaiter().fulfillment(of: [XCTestExpectation()], timeout: 3)
        assertSnapshot(of: navVC, as: .image)
    }
}
