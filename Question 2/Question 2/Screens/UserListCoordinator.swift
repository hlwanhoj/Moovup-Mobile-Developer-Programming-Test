//
//  UserListCoordinator.swift
//  Question 2
//
//  Created by hlwan on 15/8/2024.
//

import Foundation
import UIKit
import ComposableArchitecture

class UserListCoordinator {
    let navigationController: UINavigationController
    
    init() {
        let listVC = UserListViewController(
            store: Store(
                initialState: UserList.State(),
                reducer: {
                    UserList()
                }
            )
        )
        navigationController = UINavigationController(rootViewController: listVC)
        navigationController.navigationBar.tintColor = .white
        navigationController.tabBarItem = UITabBarItem(
            title: String(localized: "tab-bar-user-list"),
            image: UIImage(systemName: "list.bullet"),
            tag: 0
        )
    }
}
