//
//  Profile.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 21/08/23.
//

import Foundation
import UIKit

// MARK: - DataUseProfile
typealias profileIndex = profileUser?
struct profileUser: Codable {
    let status: String
    let isError: Bool
    let data: DataUseProfile
}
struct DataUseProfile: Codable {
    var id: Int
    var fullName, username, email: String
    var image_url: String?
    let isVerified: Bool
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case username, email, image_url
        case isVerified = "is_verified"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - EditProfileResponse
struct EditProfileResponse: Codable {
    let status: String
    let isError: Bool
    let data: EditProfile
}

// MARK: - EditProfile
struct EditProfile: Codable {
    let id: Int
    let fullName: String
    let username: String
    let email: String
    let imageUrl: String
    let isVerified: Bool
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case username, email
        case imageUrl = "image_url"
        case isVerified = "is_verified"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

typealias Parameters = [String: String]

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "lazaimage.jpg"
        
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}
