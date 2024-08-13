//
//  Question_2Tests.swift
//  Question 2Tests
//
//  Created by hlwan on 12/8/2024.
//

import XCTest
import ComposableArchitecture
@testable import Question_2

final class Question_2Tests: XCTestCase {
    enum TestUserListError: Error {
        case `default`
    }
    
    let defaultUsers: [User] = [
        User(id: "0000", name: nil, email: "abc@abc.com", pictureUrlString: nil, location: nil),
    ]
    var testClock: TestClock<Duration>!
    
    override func setUp() {
        super.setUp()
        testClock = TestClock()
    }
    
    @MainActor
    func testUserListReload() async throws {
        let clock = testClock!
        let users = defaultUsers
        let store = TestStore(
            initialState: UserList.State(),
            reducer: {
                UserList()
            },
            withDependencies: {
                $0.userAPI.getUsers = {
                    try await clock.sleep(for: .seconds(2))
                    return users
                }
            }
        )
        
        await store.send(.reload) {
            $0.isLoading = true
        }
        await testClock.run()
        await store.receive(\.receiveResponse, timeout: 3_000_000) {
            $0.isLoading = false
            $0.error = nil
            $0.users = users
        }
    }
    
    @MainActor
    func testUserListReloadWithCancellation() async throws {
        let clock = testClock!
        let users = defaultUsers
        let store = TestStore(
            initialState: UserList.State(),
            reducer: {
                UserList()
            },
            withDependencies: {
                $0.userAPI.getUsers = {
                    try await clock.sleep(for: .seconds(2))
                    return users
                }
            }
        )
        
        await store.send(.reload) {
            $0.isLoading = true
        }
        await clock.advance(by: .seconds(1))
        await store.send(.reload)
        await clock.run()
        await store.receive(\.receiveResponse, timeout: 3_000_000) {
            $0.isLoading = false
            $0.error = nil
            $0.users = users
        }
    }
    
    @MainActor
    func testUserListReloadWithError() async throws {
        let clock = testClock!
        let store = TestStore(
            initialState: UserList.State(),
            reducer: {
                UserList()
            },
            withDependencies: {
                $0.userAPI.getUsers = {
                    throw TestUserListError.default
                }
            }
        )
        
        await store.send(.reload) {
            $0.isLoading = true
        }
        await clock.run()
        await store.receive(\.receiveResponse, timeout: 3_000_000) {
            $0.isLoading = false
            $0.error = TestUserListError.default
            $0.users = []
        }
    }
}
