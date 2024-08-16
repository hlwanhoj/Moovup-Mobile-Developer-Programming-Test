//
//  MapViewController.swift
//  Question 2
//
//  Created by hlwan on 16/8/2024.
//

import Foundation
import UIKit
import MapKit
import ComposableArchitecture
import Then
import TinyConstraints
import API

class MapViewController: UIViewController, MKMapViewDelegate {
    private let store: Store<UserList.State, UserList.Action>
    private lazy var mapView = MKMapView()
    
    init(store: Store<UserList.State, UserList.Action>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubviews {
            mapView
        }
        
        view.do {
            $0.backgroundColor = Constants.Color.traitWhite
        }
        mapView.do {
            $0.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "marker")
            $0.delegate = self
            $0.edgesToSuperview(excluding: .bottom)
            $0.bottomToSuperview(usingSafeArea: true)
        }

        observe { [weak self] in
            guard let self else { return }
            
            let annotations = store.users
                .compactMap { user -> MKPointAnnotation? in
                    if let coordinate = UserFormatter.coordinate(for: user) {
                        let annotation = MKPointAnnotation()
                        annotation.title = UserFormatter.name(for: user)
                        annotation.coordinate = coordinate
                        return annotation
                    }
                    return nil
                }
            mapView.addAnnotations(annotations)
            mapView.showAnnotations(annotations, animated: false)
        }
        
        store.send(.reload)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: "marker", for: annotation)
        if let view = view as? MKMarkerAnnotationView {
            view.displayPriority = .required
            view.annotation = annotation
            view.canShowCallout = true
            view.detailCalloutAccessoryView = UILabel().then {
                $0.numberOfLines = 0
                $0.width(max: 200)
            }
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        mapView.setRegion(
            MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000),
            animated: true
        )
    }
}

#Preview("Default") {
    UINavigationController(
        rootViewController: MapViewController(
            store: Store(
                initialState: UserList.State(),
                reducer: {
                    UserList()
                },
                withDependencies: {
                    $0.userAPI.getUsers = {
                        [
                            User(
                                id: "0000",
                                name: nil,
                                email: "abc@abc.com"
                            ),
                            User(
                                id: "0001",
                                name: User.Name(first: "Mei Ling", last: "Lee"),
                                email: "def@abc.com",
                                pictureUrlString: "https://placebear.com/222/207",
                                location: User.Location(latitude: 22.32, longitude: 114.32)
                            ),
                            User(
                                id: "0002",
                                name: User.Name(first: "Hans", last: "Wong"),
                                email: "ghi@abc.com", 
                                pictureUrlString: "https://placebear.com/400/800",
                                location: User.Location(latitude: 22.19, longitude: 114.28)
                            ),
                            User(
                                id: "0003",
                                name: User.Name(first: "Alexander Benjamin Theodore Montgomery III", last: nil),
                                email: "abc@abc.com", 
                                pictureUrlString: "https://placebear.com/800/400",
                                location: User.Location(latitude: 22.39, longitude: 114.08)
                            ),
                        ]
                    }
                }
            )
        )
    )
}
