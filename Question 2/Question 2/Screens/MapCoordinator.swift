//
//  MapCoordinator.swift
//  Question 2
//
//  Created by hlwan on 16/8/2024.
//

import Foundation
import UIKit
import ComposableArchitecture

class MapCoordinator {
    let store: Store<UserList.State, UserList.Action>
    let navigationController: UINavigationController
    
    init(store: Store<UserList.State, UserList.Action>) {
        self.store = store
        
        let mapVC = MapViewController(store: store)
        navigationController = UINavigationController(rootViewController: mapVC)
        navigationController.navigationBar.tintColor = Constants.Color.traitBlue
        navigationController.tabBarItem = UITabBarItem(
            title: String(localized: "tab-bar-map"),
            image: UIImage(systemName: "map"),
            tag: 0
        )
    }
}
