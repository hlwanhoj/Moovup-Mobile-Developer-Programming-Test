//
//  UserList.swift
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
    
    var name: String {
        if let name = user.name {
            return [name.first, name.last].compactMap { $0 }.joined(separator: " ")
        }
        return "<No Name>"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(user.id)
    }
}

@Reducer
class UserList {
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
        case reload, receiveResponse(Result<[User], Error>)
    }
    
    enum CancelID {
        case reload
    }

    @Dependency(\.userAPI) var userAPI
    
    var body: some ReducerOf<UserList> {
        Reduce { state, action in
            switch action {
            case .reload:
                state.isLoading = true
                return .run { send in
                    await send(
                        .receiveResponse(Result<[User], Error> {
                            try await self.userAPI.getUsers()
                        })
                    )
                }
                .cancellable(id: CancelID.reload, cancelInFlight: true)
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
