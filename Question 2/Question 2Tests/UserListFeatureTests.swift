//
//  UserListFeatureTests.swift
//  Question 2Tests
//
//  Created by hlwan on 12/8/2024.
//

import XCTest
import ComposableArchitecture
import SnapshotTesting
import API
@testable import Question_2

final class UserListFeatureTests: XCTestCase {
    enum TestUserListError: Error {
        case `default`
    }
    
    let defaultUsers: [User] = [
        User(id: "0000", name: nil, email: "abc@abc.com"),
        User(id: "0001", name: User.Name(first: "Mei Ling", last: "Lee"), email: "def@abc.com", pictureUrlString: "https://placebear.com/222/207"),
        User(id: "0002", name: User.Name(first: "Hans", last: "Wong"), email: "ghi@abc.com", pictureUrlString: "https://placebear.com/400/800"),
        User(id: "0003", name: User.Name(first: "Alexander Benjamin Theodore Montgomery III", last: nil), email: "abc@abc.com", pictureUrlString: "https://placebear.com/800/400"),
    ]
    var testClock: TestClock<Duration>!
    
    override func setUpWithError() throws {
        testClock = TestClock()
    }
    
    @MainActor
    func testUserListReload() async throws {
        let clock = testClock!
        let defaultUsers = defaultUsers
        let store = TestStore(
            initialState: UserListFeature.State(),
            reducer: {
                UserListFeature()
            },
            withDependencies: {
                $0.userAPI.getUsers = {
                    try await clock.sleep(for: .seconds(2))
                    return defaultUsers
                }
                $0.usersFetcher = UsersFetcher()
            }
        )
        store.exhaustivity = .off
        
        await store.send(.listen)
        XCTAssert(store.state.snapshot.itemIdentifiers.isEmpty)
        await store.send(.reload)
        await store.receive(\.setLoading) {
            $0.isLoading = true
        }
        XCTAssert(store.state.snapshot.itemIdentifiers.isEmpty)
        await testClock.run()
        await store.receive(\.receiveResponse) {
            $0.isLoading = false
            $0.error = nil
            $0.users = defaultUsers
        }
        XCTAssert(store.state.snapshot.itemIdentifiers.count == defaultUsers.count)
        await store.send(.reload)
        await store.receive(\.setLoading) {
            $0.isLoading = true
        }
        XCTAssert(store.state.snapshot.itemIdentifiers.count == defaultUsers.count)
        await testClock.run()
        await store.receive(\.receiveResponse) {
            $0.isLoading = false
            $0.error = nil
            $0.users = defaultUsers
        }
        XCTAssert(store.state.snapshot.itemIdentifiers.count == defaultUsers.count)
    }
    
    @MainActor
    func testUserListReloadWithError() async throws {
        let clock = testClock!
        let store = TestStore(
            initialState: UserListFeature.State(),
            reducer: {
                UserListFeature()
            },
            withDependencies: {
                $0.userAPI.getUsers = {
                    await XCTWaiter().fulfillment(of: [XCTestExpectation()], timeout: 0.5)
                    throw TestUserListError.default
                }
                $0.usersFetcher = UsersFetcher()
            }
        )
        store.exhaustivity = .off
        
        await store.send(.listen)
        XCTAssert(store.state.snapshot.itemIdentifiers.isEmpty)
        await store.send(.reload)
        await store.receive(\.setLoading) {
            $0.isLoading = true
        }
        XCTAssert(store.state.snapshot.itemIdentifiers.isEmpty)
        await clock.run()
        await store.receive(\.receiveResponse) {
            $0.isLoading = false
            $0.error = TestUserListError.default
            $0.users = []
        }
        XCTAssert(store.state.snapshot.itemIdentifiers.isEmpty)
        await store.send(.reload)
        await store.receive(\.setLoading) {
            $0.isLoading = true
        }
        XCTAssert(store.state.snapshot.itemIdentifiers.isEmpty)
        await clock.run()
        await store.receive(\.receiveResponse) {
            $0.isLoading = false
            $0.error = TestUserListError.default
            $0.users = []
        }
        XCTAssert(store.state.snapshot.itemIdentifiers.isEmpty)
    }
    
    // MARK: - UI Snapshots

    @MainActor
    func testUserListVC() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let navVC = UINavigationController(
            rootViewController: UserListViewController(
                store: Store(
                    initialState: UserListFeature.State(),
                    reducer: {
                        UserListFeature()
                    },
                    withDependencies: { dependencies in
                        dependencies.userAPI.getUsers = {
                            [
                                User(id: "0000", name: nil, email: "abc@abc.com"),
                                User(id: "0001", name: User.Name(first: "Mei Ling", last: "Lee"), email: "def@abc.com", pictureUrlString: "https://placebear.com/222/207"),
                                User(id: "0002", name: User.Name(first: "Hans", last: "Wong"), email: "ghi@abc.com", pictureUrlString: "https://placebear.com/400/800"),
                                User(id: "0003", name: User.Name(first: "Alexander Benjamin Theodore Montgomery III", last: nil), email: "abc@abc.com", pictureUrlString: "https://placebear.com/800/400"),
                            ]
                        }
                        
                        let usersFetcher = dependencies.usersFetcher
                        Task {
                            await usersFetcher.reload()
                        }
                    }
                )
            )
        )
        navVC.loadViewIfNeeded()
        navVC.view.setNeedsLayout()
        navVC.view.layoutIfNeeded()

        await XCTWaiter().fulfillment(of: [XCTestExpectation()], timeout: 3)
        assertSnapshot(of: navVC, as: .image(on: .iPhone13ProMax(.portrait), precision: 3, perceptualPrecision: 3))
    }
}
