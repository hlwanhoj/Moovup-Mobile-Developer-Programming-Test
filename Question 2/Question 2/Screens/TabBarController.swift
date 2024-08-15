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
        
        tabBar.tintColor = UIColor(dynamicProvider: { trait in
            if trait.userInterfaceStyle == .dark {
                UIColor(white: 1, alpha: 1)
            } else {
                UIColor.systemBlue
            }
        })
        setViewControllers([userListCoordinator.navigationController], animated: false)
    }
}
