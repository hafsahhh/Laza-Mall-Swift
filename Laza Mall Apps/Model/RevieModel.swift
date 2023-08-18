//
//  RevieModel.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 18/08/23.
//

import Foundation
typealias ReviewAll = ResponseReview?
struct ResponseReview: Codable {
    let status: String
    let isError: Bool
    let data: DataReview
}

// MARK: - DataClass
struct DataReview: Codable {
    let ratingAvrg: Double
    let total: Int
    let reviews: [ReviewAllProduct]

    enum CodingKeys: String, CodingKey {
        case ratingAvrg = "rating_avrg"
        case total, reviews
    }
}

// MARK: - Review
struct ReviewAllProduct: Codable {
    let id: Int
    let comment: String
    let rating: Double
    let fullName: FullName
    let imageURL: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, comment, rating
        case fullName = "full_name"
        case imageURL = "image_url"
        case createdAt = "created_at"
    }
}

enum FullName: String, Codable {
    case adminUser = "Admin User"
    case edwardkenway = "edwardkenway"
    case madaDwiSaputra = "Mada Dwi Saputra"
}

