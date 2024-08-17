//
//  UIStackView+Creation.swift
//  Question 2
//
//  Created by hlwan on 14/8/2024.
//

import Foundation
import Then
import UIKit

public extension UIStackView {
    static func horizontal(alignment: Alignment = .fill, distribution: Distribution = .fill, spacing: CGFloat = 0) -> UIStackView {
        UIStackView().then {
            $0.axis = .horizontal
            $0.alignment = alignment
            $0.distribution = distribution
            $0.spacing = spacing
        }
    }
    
    static func vertical(alignment: Alignment = .fill, distribution: Distribution = .fill, spacing: CGFloat = 0) -> UIStackView {
        UIStackView().then {
            $0.axis = .vertical
            $0.alignment = alignment
            $0.distribution = distribution
            $0.spacing = spacing
        }
    }
}
