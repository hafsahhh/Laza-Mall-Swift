//
//  AddressModel.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 24/08/23.
//

import Foundation

// MARK: - AllAddress
struct ResponseAllAddress: Codable {
    let status: String
    let isError: Bool
    var data: [DataAllAddress]
}

// MARK: - Datum
struct DataAllAddress: Codable {
    let id: Int
    let country, city, receiverName, phoneNumber: String
    let userID: Int
    let user: UserAddress
    let isPrimary: Bool?

    enum CodingKeys: String, CodingKey {
        case id, country, city
        case receiverName = "receiver_name"
        case phoneNumber = "phone_number"
        case userID = "user_id"
        case user
        case isPrimary = "is_primary"
    }
}

// MARK: - User
struct UserAddress: Codable {
    let id: Int
    let username, email, fullName: String
    let createdAt, updatedAt: String
    let deletedAt: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id, username, email
        case fullName = "full_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}
