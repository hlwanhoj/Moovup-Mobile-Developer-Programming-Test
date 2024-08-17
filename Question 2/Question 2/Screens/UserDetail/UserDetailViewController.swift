//
//  UserDetailViewController.swift
//  Question 2
//
//  Created by hlwan on 15/8/2024.
//

import Foundation
import UIKit
import MapKit
import ComposableArchitecture
import Then
import TinyConstraints
import Kingfisher
import API

class UserDetailViewController: UIViewController {
    private static let processor = DownsamplingImageProcessor(size: CGSize(width: 80, height: 80))
    private let store: Store<UserDetailFeature.State, UserDetailFeature.Action>
    private lazy var mapView = MKMapView()
    private lazy var locationAlertView = UserDetailLocationAlertView()
    private lazy var iconView = UIImageView()
    private lazy var titleLabel = UILabel()
    private lazy var emailLabel = UILabel()
    
    init(store: Store<UserDetailFeature.State, UserDetailFeature.Action>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vStack = UIStackView.vertical()
        let mapViewWrapper = UIView()
        let hStackWrapper = UIView()
        let hStack = UIStackView.horizontal()
        let separator = UIView()
        let infoVStack = UIStackView.vertical()
        view.addSubviews {
            vStack.addArrangedSubviews {
                mapViewWrapper.addSubviews {
                    mapView
                    locationAlertView
                }
                separator
                hStackWrapper.addSubviews {
                    hStack.addArrangedSubviews {
                        iconView
                        12
                        infoVStack.addArrangedSubviews {
                            titleLabel
                            6
                            emailLabel
                        }
                    }
                }
            }
        }
        
        view.do {
            $0.backgroundColor = Constants.Color.traitWhite
        }
        vStack.do {
            $0.edgesToSuperview()
        }
        mapView.do {
            $0.edgesToSuperview()
        }
        locationAlertView.do {
            $0.leftToSuperview(offset: 24, relation: .equalOrGreater)
            $0.rightToSuperview(offset: -24, relation: .equalOrLess)
            $0.centerInSuperview()
        }
        separator.do {
            $0.backgroundColor = UIColor(white: 0.8, alpha: 1)
            $0.height(1)
        }
        hStack.do {
            $0.isLayoutMarginsRelativeArrangement = true
            $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
            $0.insetsLayoutMarginsFromSafeArea = false
            $0.alignment = .center
            $0.height(80)
            $0.edgesToSuperview(insets: .vertical(16), usingSafeArea: true)
        }
        iconView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
            $0.aspectRatio(1)
            $0.topToSuperview($0.superview?.layoutMarginsGuide.topAnchor)
            $0.bottomToSuperview($0.superview?.layoutMarginsGuide.bottomAnchor)
        }
        titleLabel.do {
            $0.numberOfLines = 0
        }
        emailLabel.do {
            $0.font = UIFont.systemFont(ofSize: 14)
        }

        observe { [weak self] in
            guard let self else { return }
            if let coordinate = UserFormatter.coordinate(for: store.user) {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                mapView.addAnnotation(annotation)
                mapView.region = MKCoordinateRegion(
                    center: coordinate,
                    latitudinalMeters: 5000,
                    longitudinalMeters: 5000
                )
                locationAlertView.isHidden = true
            } else {
                locationAlertView.title = store.locationAlertText
                locationAlertView.isHidden = false
            }
            titleLabel.text = UserFormatter.name(for: store.user)
            emailLabel.text = store.user.email
            KF.url(store.user.pictureUrl)
                .setProcessor(Self.processor)
                .scaleFactor(UIScreen.main.scale)
                .loadDiskFileSynchronously()
                .placeholder(Constants.ImagePlaceholders.listItem)
                .fade(duration: 0.25)
                .set(to: iconView)
        }
    }
}

#Preview("Default") {
    UINavigationController(
        rootViewController: UserDetailViewController(
            store: Store(
                initialState: UserDetailFeature.State(
                    user: User(
                        id: "0003",
                        name: User.Name(first: "Alexander Benjamin Theodore Montgomery III", last: nil),
                        email: "abc@abc.com",
                        pictureUrlString: "https://placebear.com/800/400",
                        location: User.Location(latitude: 22.39, longitude: 114.08)
                    )
                ),
                reducer: {
                    UserDetailFeature()
                }
            )
        )
    )
}
#Preview("No Location") {
    UINavigationController(
        rootViewController: UserDetailViewController(
            store: Store(
                initialState: UserDetailFeature.State(
                    user: User(
                        id: "0003",
                        name: User.Name(first: "Alexander Benjamin Theodore Montgomery III", last: nil),
                        email: "abc@abc.com",
                        pictureUrlString: "https://placebear.com/800/400",
                        location: nil
                    )
                ),
                reducer: {
                    UserDetailFeature()
                }
            )
        )
    )
}
