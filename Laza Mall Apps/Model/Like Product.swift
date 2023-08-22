//
//  Like Product.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 06/08/23.
//

import Foundation

// MARK: - Welcome
typealias WishlistProductIndex = wishlistIndex?
struct wishlistIndex: Codable {
    let status: String
    let isError: Bool
    let data: wishlistResponse?
}

// MARK: - DataClass
struct wishlistResponse: Codable {
    let total: Int
    let products: [ProductWishlistEntry]
}

// MARK: - Product
struct ProductWishlistEntry: Codable {
    let id: Int
    let name: String
    let imageURL: String
    let price: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "image_url"
        case price
        case createdAt = "created_at"
    }
}
struct UpdateWishlist: Codable {
    let status: String
    let isError: Bool
    let data: String
}
