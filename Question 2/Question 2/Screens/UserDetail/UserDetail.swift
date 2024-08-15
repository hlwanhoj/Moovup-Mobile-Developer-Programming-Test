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
        
        var locationAlertText: String {
            "Location not found for current user."
        }
    }
    
    enum Action {
    }
    
    var body: some ReducerOf<UserDetail> {
        Reduce { _, _ in
            return .none
        }
    }
}
