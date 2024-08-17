//
//  UserDetailLocationAlertView.swift
//  Question 2
//
//  Created by hlwan on 15/8/2024.
//

import Foundation
import UIKit

class UserDetailLocationAlertView: UIView {
    private lazy var iconView = UIImageView()
    private lazy var titleLabel = UILabel()

    var title: String? {
        get { titleLabel.text }
        set {
            titleLabel.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let hStack = UIStackView.horizontal(alignment: .center)
        addSubviews {
            hStack.addArrangedSubviews {
                iconView
                12
                titleLabel
            }
        }
        
        self.do {
            $0.layer.cornerRadius = 8
            $0.layer.shadowOpacity = 0.3
            $0.layer.shadowOffset = CGSize(width: 2, height: 6)
            $0.backgroundColor = Constants.Color.traitWhite
        }
        hStack.do {
            $0.edgesToSuperview(insets: .uniform(16))
        }
        iconView.do {
            $0.image = UIImage(systemName: "exclamationmark.circle")
            $0.tintColor = .red
        }
        titleLabel.do {
            $0.numberOfLines = 0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview("default", traits: .fixedLayout(width: 375, height: 80)) {
    UserDetailLocationAlertView().then {
        $0.title = "Missing MeshRenderables for ground mesh layer for (4/4) of ground tiles."
    }
}
