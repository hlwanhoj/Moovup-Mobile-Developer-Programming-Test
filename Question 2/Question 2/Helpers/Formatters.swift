//
//  Formatters.swift
//  Question 2
//
//  Created by hlwan on 15/8/2024.
//

import Foundation
import API
import CoreLocation

struct UserFormatter {
    static func name(for user: User) -> String {
        if let name = user.name {
            return [name.first, name.last].compactMap { $0 }.joined(separator: " ")
        }
        return "<No Name>"
    }
    
    static func coordinate(for user: User) -> CLLocationCoordinate2D? {
        if let location = user.location, let latitude = location.latitude, let longitude = location.longitude {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return nil
    }
}
