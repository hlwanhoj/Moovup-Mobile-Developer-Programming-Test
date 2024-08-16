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
    private let store: Store<UserListFeature.State, UserListFeature.Action> = Store(
        initialState: UserListFeature.State(),
        reducer: {
            UserListFeature()
        }
    )
    private lazy var userListCoordinator = UserListCoordinator()
    private lazy var mapCoordinator = MapCoordinator()
    @Dependency(\.usersFetcher) var usersFetcher

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
        
        Task {
            await usersFetcher.reload()
        }
    }
}
