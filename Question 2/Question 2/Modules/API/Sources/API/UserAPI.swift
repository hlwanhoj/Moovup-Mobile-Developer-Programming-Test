//
//  UserAPI.swift
//  Question 2
//
//  Created by hlwan on 13/8/2024.
//

import Foundation
import Alamofire
import ComposableArchitecture

/**
 It needs to be a `class` for dependency mocking to work, as its a dependency of `UsersFetcher`, and some screen use `UsersFetcher` as dependency.
 */
public class UserAPI {
    enum Error: Swift.Error {
        case bundleNotFound
    }
    
    public var getUsers: () async throws -> [User]
    
    public init(getUsers: @escaping () async throws -> [User]) {
        self.getUsers = getUsers
    }
}

extension UserAPI: DependencyKey {
    public static let liveValue = UserAPI(
        getUsers: {
            try await AF
                .request(
                    "https://api.json-generator.com/templates/-xdNcNKYtTFG/data",
                    headers: [.authorization(bearerToken: "b2atclr0nk1po45amg305meheqf4xrjt9a1bo410")]
                )
                .serializingDecodable([User].self)
                .value
        }
    )
}

public extension DependencyValues {
    var userAPI: UserAPI {
        get { self[UserAPI.self] }
        set { self[UserAPI.self] = newValue }
    }
}
