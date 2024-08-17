//
//  User.swift
//  Question 2
//
//  Created by hlwan on 13/8/2024.
//

import Foundation

public struct User: Decodable, Equatable {
    public struct Name: Decodable {
        public let first: String?
        public let last: String?

        public init(first: String? = nil, last: String? = nil) {
            self.first = first
            self.last = last
        }
    }
    public struct Location: Decodable {
        public let latitude: Double?
        public let longitude: Double?

        public init(latitude: Double? = nil, longitude: Double? = nil) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case pictureUrlString = "picture"
        case name, email, location
    }

    public let id: String
    public let name: Name?
    public let email: String?
    public let pictureUrlString: String?
    public let location: Location?
    
    public init(
        id: String,
        name: User.Name? = nil,
        email: String? = nil,
        pictureUrlString: String? = nil,
        location: User.Location? = nil
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.pictureUrlString = pictureUrlString
        self.location = location
    }

    public var pictureUrl: URL? {
        pictureUrlString.flatMap { URL(string: $0) }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
