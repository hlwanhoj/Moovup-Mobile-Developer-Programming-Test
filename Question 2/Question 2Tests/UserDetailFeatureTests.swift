//
//  UserDetailFeatureTests.swift
//  Question 2Tests
//
//  Created by hlwan on 17/8/2024.
//

import XCTest
import ComposableArchitecture
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
}
