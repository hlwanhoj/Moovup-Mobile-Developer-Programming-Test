//
//  UserListCell.swift
//  Question 2
//
//  Created by hlwan on 14/8/2024.
//

import Foundation
import UIKit
import Kingfisher

class UserListCell: UITableViewCell {
    private lazy var iconView = UIImageView()
    private lazy var titleLabel = UILabel()
    private static let processor = DownsamplingImageProcessor(size: CGSize(width: 80, height: 80))

    var title: String? {
        get { titleLabel.text }
        set {
            titleLabel.text = newValue
        }
    }
    
    var iconUrl: URL? {
        didSet {
            KF.url(iconUrl)
                .setProcessor(Self.processor)
                .scaleFactor(UIScreen.main.scale)
                .loadDiskFileSynchronously()
                .placeholder(ImagePlaceholders.listItem)
                .fade(duration: 0.25)
                .set(to: iconView)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let hStack = UIStackView.horizontal()
        contentView.addSubviews {
            hStack.addArrangedSubviews {
                iconView
                12
                titleLabel
            }
        }
        
        hStack.do {
            $0.edgesToSuperview(insets: .uniform(8))
        }
        iconView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
            $0.aspectRatio(1)
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
    UserListCell(style: .default, reuseIdentifier: nil).then {
        $0.title = "Alexander Benjamin Theodore Montgomery III"
        $0.iconUrl = URL(string: "https://placebear.com/400/800")
    }
}
