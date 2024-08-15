//
//  Constants.swift
//  Question 2
//
//  Created by hlwan on 14/8/2024.
//

import Foundation
import UIKit

enum Constants {
    struct ImagePlaceholders {
        static let listItem = UIImage(named: "list-item-placeholder")
    }
    
    struct Color {
        static let traitWhite = UIColor(dynamicProvider: { trait in
            if trait.userInterfaceStyle == .dark {
                UIColor(white: 0, alpha: 1)
            } else {
                UIColor(white: 1, alpha: 1)
            }
        })
        static let traitBlue = UIColor(dynamicProvider: { trait in
            if trait.userInterfaceStyle == .dark {
                UIColor(white: 1, alpha: 1)
            } else {
                UIColor.systemBlue
            }
        })
    }
}
