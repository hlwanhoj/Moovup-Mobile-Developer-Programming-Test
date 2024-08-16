//
//  UserListFeature.swift
//  Question 2
//
//  Created by hlwan on 12/8/2024.
//

import Foundation
import UIKit
import ComposableArchitecture
import API

enum UserListSection: Hashable {
    case `default`
}

struct UserListItem: Hashable {
    let user: User
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(user.id)
    }
}

@Reducer
class UserListFeature {
    @ObservableState
    struct State: Equatable {
        var users: [User] = []
        var isLoading = false
        var error: Error?
        
        var hasError: Bool {
            error != nil
        }
        
        var snapshot: NSDiffableDataSourceSnapshot<UserListSection, UserListItem> {
            var snapshot = NSDiffableDataSourceSnapshot<UserListSection, UserListItem>()
            snapshot.appendSections([.default])
            snapshot.appendItems(users.map { UserListItem(user: $0) })
            return snapshot
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.users == rhs.users && lhs.isLoading == rhs.isLoading && lhs.hasError == rhs.hasError
        }
    }
    
    enum Action {
        case listen, reload, setLoading, receiveResponse(Result<[User], Error>)
    }

    @Dependency(\.usersFetcher) var usersFetcher
    
    var body: some ReducerOf<UserListFeature> {
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
