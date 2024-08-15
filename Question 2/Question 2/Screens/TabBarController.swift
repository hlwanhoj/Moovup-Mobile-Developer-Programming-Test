//
//  TabBarController.swift
//  Question 2
//
//  Created by hlwan on 15/8/2024.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    private lazy var userListCoordinator = UserListCoordinator()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = Constants.Color.traitBlue
        setViewControllers([userListCoordinator.navigationController], animated: false)
    }
}
