//
//  TabBarController.swift
//  Question 2
//
//  Created by hlwan on 15/8/2024.
//

import Foundation
import UIKit
import ComposableArchitecture

class TabBarController: UITabBarController {
    private let store: Store<UserList.State, UserList.Action> = Store(
        initialState: UserList.State(),
        reducer: {
            UserList()
        }
    )
    private lazy var userListCoordinator = UserListCoordinator(store: store)
    private lazy var mapCoordinator = MapCoordinator(store: store)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = Constants.Color.traitBlue
        setViewControllers(
            [
                userListCoordinator.navigationController,
                mapCoordinator.navigationController,
            ],
            animated: false
        )
    }
}
