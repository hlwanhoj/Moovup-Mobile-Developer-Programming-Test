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
    let navigationController: UINavigationController
    
    init() {
        let mapVC = MapViewController(
            store: Store(
                initialState: MapFeature.State(),
                reducer: {
                    MapFeature()
                }
            )
        )
        navigationController = UINavigationController(rootViewController: mapVC)
        navigationController.navigationBar.tintColor = Constants.Color.traitBlue
        navigationController.tabBarItem = UITabBarItem(
            title: String(localized: "tab-bar-map"),
            image: UIImage(systemName: "map"),
            tag: 0
        )
    }
}
