//
//  MapViewFeature.swift
//  Question 2
//
//  Created by hlwan on 16/8/2024.
//

import Foundation
import UIKit
import ComposableArchitecture
import API

@Reducer
class MapFeature {
    @ObservableState
    struct State: Equatable {
        var users: [User] = []
        var isLoading = false
        var error: Error?
        
        var hasError: Bool {
            error != nil
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.users == rhs.users && lhs.isLoading == rhs.isLoading && lhs.hasError == rhs.hasError
        }
    }
    
    enum Action {
        case listen, reload, setLoading, receiveResponse(Result<[User], Error>)
    }

    @Dependency(\.usersFetcher) var usersFetcher
    
    var body: some ReducerOf<MapFeature> {
        Reduce { state, action in
            switch action {
            case .listen:
                return .publisher {
                    self.usersFetcher.publisher
                        .compactMap { val in
                            switch val {
                            case .uninitialized:
                                return nil
                            case .loading:
                                return .setLoading
                            case let .success(users):
                                return .receiveResponse(.success(users))
                            case let .failure(error):
                                return .receiveResponse(.failure(error))
                            }
                        }
                        .receive(on: DispatchQueue.main)
                        .print("users fetcher")
                }
            case .reload:
                return .run(operation: { _ in
                    await self.usersFetcher.reload()
                })
            case .setLoading:
                state.isLoading = true
                return .none
            case let .receiveResponse(result):
                state.isLoading = false
                switch result {
                case let .success(users):
                    state.error = nil
                    state.users = users
                case let .failure(error):
                    state.error = error
                    state.users = []
                }
                return .none
            }
        }
    }
}
