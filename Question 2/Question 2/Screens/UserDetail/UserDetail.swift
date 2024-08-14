//
//  UserDetail.swift
//  Question 2
//
//  Created by hlwan on 15/8/2024.
//

import Foundation
import UIKit
import ComposableArchitecture
import API

@Reducer
class UserDetail {
    @ObservableState
    struct State: Equatable {
        let user: User
    }
    
    enum Action {
    }
    
    var body: some ReducerOf<UserDetail> {
        Reduce { state, action in
            return .none
        }
    }
}
