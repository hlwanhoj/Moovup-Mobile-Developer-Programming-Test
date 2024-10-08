//
//  UserDetailFeature.swift
//  Question 2
//
//  Created by hlwan on 15/8/2024.
//

import Foundation
import UIKit
import ComposableArchitecture
import API

@Reducer
class UserDetailFeature {
    @ObservableState
    struct State: Equatable {
        let user: User
        
        var locationAlertText: String {
            String(localized: "user-detail-location-alert")
        }
    }
    
    enum Action {
    }
    
    var body: some ReducerOf<UserDetailFeature> {
        Reduce { _, _ in
            return .none
        }
    }
}
