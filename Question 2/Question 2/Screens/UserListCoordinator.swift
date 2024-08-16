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
    let store: Store<UserList.State, UserList.Action>
    let navigationController: UINavigationController
    
    init(store: Store<UserList.State, UserList.Action>) {
        self.store = store
        
        let listVC = UserListViewController(store: store)
        navigationController = UINavigationController(rootViewController: listVC)
        navigationController.navigationBar.tintColor = Constants.Color.traitBlue
        navigationController.tabBarItem = UITabBarItem(
            title: String(localized: "tab-bar-user-list"),
            image: UIImage(systemName: "list.bullet"),
            tag: 0
        )
        
        listVC.didSelectUser = { [weak self] user in
            guard let self else { return }
            
            let detailVC = UserDetailViewController(
                store: Store(
                    initialState: UserDetail.State(
                        user: user
                    ),
                    reducer: {
                        UserDetail()
                    }
                )
            )
            navigationController.pushViewController(detailVC, animated: true)
        }
    }
}
