//
//  UsersFetcher.swift
//  Question 2
//
//  Created by hlwan on 16/8/2024.
//

import Foundation
import Combine
import ComposableArchitecture
import API

public enum APIResult<Success, Failure> where Failure: Error {
    case uninitialized

    /// Result is pending
    case loading
    
    /// A success, storing a `Success` value.
    case success(Success)
    
    /// A failure, storing a `Failure` value.
    case failure(Failure)
}

/**
 Use actor to ensure thread safety.
 */
public actor UsersFetcher {
    private let value = CurrentValueSubject<APIResult<[User], Error>, Never>(.uninitialized)
    private let lock = NSLock()
    @Dependency(\.userAPI) private var userAPI
    
    nonisolated var publisher: AnyPublisher<APIResult<[User], Error>, Never> {
        value.eraseToAnyPublisher()
    }
    
    /**
     Call API to fetch users. Do nothing when it's already loading.
     */
    func reload() async {
        if case .loading = value.value {
            return
        }

        value.send(.loading)
        do {
            let users = try await userAPI.getUsers()
            value.send(.success(users))
        } catch {
            value.send(.failure(error))
        }
    }
}

extension UsersFetcher: DependencyKey {
    public static let liveValue = UsersFetcher()
    public static var testValue = UsersFetcher()
}

public extension DependencyValues {
    var usersFetcher: UsersFetcher {
        get { self[UsersFetcher.self] }
        set { self[UsersFetcher.self] = newValue }
    }
}
