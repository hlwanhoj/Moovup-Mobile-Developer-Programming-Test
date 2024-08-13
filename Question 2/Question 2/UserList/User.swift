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
    }
    public struct Location: Decodable {
        public let latitude: Double?
        public let longitude: Double?
    }

    public let id: String
    public let name: Name?
    public let email: String?
    public let pictureUrlString: String?
    public let location: Location?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case pictureUrlString = "picture"
        case name, email, location
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
