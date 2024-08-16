//
//  UsersFetcherTests.swift
//  Question 2Tests
//
//  Created by hlwan on 16/8/2024.
//

import XCTest
import Combine
import ComposableArchitecture
import API
@testable import Question_2

final class UsersFetcherTests: XCTestCase {
    enum Error: Swift.Error {
        case custom(String)
    }
    
    let defaultUsers: [User] = [
        User(id: "0000", name: nil, email: "abc@abc.com"),
        User(id: "0001", name: User.Name(first: "Mei Ling", last: "Lee"), email: "def@abc.com", pictureUrlString: "https://placebear.com/222/207"),
        User(id: "0002", name: User.Name(first: "Hans", last: "Wong"), email: "ghi@abc.com", pictureUrlString: "https://placebear.com/400/800"),
        User(id: "0003", name: User.Name(first: "Alexander Benjamin Theodore Montgomery III", last: nil), email: "abc@abc.com", pictureUrlString: "https://placebear.com/800/400"),
    ]
    
    func testNormalCase() async throws {
        let defaultUsers = defaultUsers
        try await withDependencies {
            $0.userAPI.getUsers = {
                await XCTWaiter().fulfillment(of: [XCTestExpectation()], timeout: 0.2)
                return defaultUsers
            }
            $0.usersFetcher = UsersFetcher()
        } operation: {
            @Dependency(\.usersFetcher) var usersFetcher
            let publisher = usersFetcher.publisher.prefix(5)
            var idx = 0
            for await result in publisher.values {
                switch idx {
                case 0:
                    guard case .uninitialized = result else {
                        throw Error.custom("Result should be `uninitialized`")
                    }
                    Task {
                        await usersFetcher.reload()
                    }
                case 1:
                    guard case .loading = result else {
                        throw Error.custom("Result should be `loading`")
                    }
                case 2:
                    guard case let .success(users) = result, users == defaultUsers else {
                        throw Error.custom("Result should be `success`")
                    }
                    Task {
                        await usersFetcher.reload()
                    }
                case 3:
                    guard case .loading = result else {
                        throw Error.custom("Result should be `loading`")
                    }
                case 4:
                    guard case let .success(users) = result, users == defaultUsers else {
                        throw Error.custom("Result should be `success`")
                    }
                default:
                    break
                }
                idx += 1
            }
        }
    }
    
    func testQuickReload() async throws {
        let defaultUsers = defaultUsers
        try await withDependencies {
            $0.userAPI.getUsers = {
                await XCTWaiter().fulfillment(of: [XCTestExpectation()], timeout: 0.5)
                return defaultUsers
            }
            $0.usersFetcher = UsersFetcher()
        } operation: {
            @Dependency(\.usersFetcher) var usersFetcher
            let publisher = usersFetcher.publisher.prefix(3)
            var idx = 0
            for await result in publisher.values {
                switch idx {
                case 0:
                    guard case .uninitialized = result else {
                        throw Error.custom("Result should be `uninitialized`")
                    }
                    Task {
                        await usersFetcher.reload()
                    }
                    Task {
                        await usersFetcher.reload()
                    }
                    Task {
                        await usersFetcher.reload()
                    }
                case 1:
                    guard case .loading = result else {
                        throw Error.custom("Result should be `loading`")
                    }
                case 2:
                    guard case let .success(users) = result, users == defaultUsers else {
                        throw Error.custom("Result should be `success`")
                    }
                default:
                    break
                }
                idx += 1
            }
        }
    }
    
    func testErrorCase() async throws {
        try await withDependencies {
            $0.userAPI.getUsers = {
                await XCTWaiter().fulfillment(of: [XCTestExpectation()], timeout: 0.5)
                throw Error.custom("Something went wrong")
            }
            $0.usersFetcher = UsersFetcher()
        } operation: {
            @Dependency(\.usersFetcher) var usersFetcher
            let publisher = usersFetcher.publisher.prefix(3)
            var idx = 0
            for await result in publisher.values {
                switch idx {
                case 0:
                    guard case .uninitialized = result else {
                        throw Error.custom("Result should be `uninitialized`")
                    }
                    Task {
                        await usersFetcher.reload()
                    }
                case 1:
                    guard case .loading = result else {
                        throw Error.custom("Result should be `loading`")
                    }
                case 2:
                    guard case .failure = result else {
                        throw Error.custom("Result should be `failure`")
                    }
                default:
                    break
                }
                idx += 1
            }
        }
    }
}
