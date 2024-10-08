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
                initialState: UserListFeature.State(),
                reducer: {
                    UserListFeature()
                }
            )
        )
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
                    initialState: UserDetailFeature.State(
                        user: user
                    ),
                    reducer: {
                        UserDetailFeature()
                    }
                )
            )
            navigationController.pushViewController(detailVC, animated: true)
        }
    }
}
