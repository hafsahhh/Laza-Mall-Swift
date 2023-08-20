//
//  BrandModel.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 20/08/23.
//

import Foundation

// MARK: - Brand Product
typealias brandIndex = brandResponse?
struct brandResponse: Codable {
    let status: String
    let isError: Bool
    let data: brandEntry
}

struct brandEntry: Codable {
    let id: Int
    let name: String
    let logo_url: String
    let deleted_at: String?
}
