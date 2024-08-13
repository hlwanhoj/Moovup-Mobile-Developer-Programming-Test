//
//  UserAPI.swift
//  Question 2
//
//  Created by hlwan on 13/8/2024.
//

import Foundation
import Alamofire
import ComposableArchitecture

public struct UserAPI {
    enum Error: Swift.Error {
        case bundleNotFound
    }
    
    public var getUsers: () async throws -> [User]
}

extension UserAPI: DependencyKey {
    public static let liveValue = Self(
        getUsers: {
            try await AF.request("https://api.json-generator.com/templates/-xdNcNKYtTFG/data")
                .serializingDecodable([User].self).value
        }
    )
}

public extension DependencyValues {
    var userAPI: UserAPI {
        get { self[UserAPI.self] }
        set { self[UserAPI.self] = newValue }
    }
}
