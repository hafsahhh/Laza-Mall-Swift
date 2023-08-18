//
//  DetailProdModel.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 18/08/23.
//

import Foundation
// MARK: - Detail Product Response
typealias ProductDetailIndex = DetailProductResponse?
struct DetailProductResponse: Codable {
    let status: String
    let isError: Bool
    let data: DataDetailProduct
}

// MARK: - Data Detail Product
struct DataDetailProduct: Codable {
    let id: Int
    let name, description: String
    let imageURL: String
    let price, brandID: Int
    let category: Category
    let size: [Size]
    let reviews: [Review]
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case imageURL = "image_url"
        case price
        case brandID = "brand_id"
        case category, size, reviews
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let category: String
}

// MARK: - Review
struct Review: Codable {
    let id: Int
    let comment: String
    let rating: Double
    let fullName, imageURL, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, comment, rating
        case fullName = "full_name"
        case imageURL = "image_url"
        case createdAt = "created_at"
    }
}

// MARK: - Size
struct Size: Codable {
    let id: Int
    let size: String
}
