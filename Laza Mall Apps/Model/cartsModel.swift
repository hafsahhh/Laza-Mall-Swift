//
//  cartsModel.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 23/08/23.
//

import Foundation
// MARK: - CartsIndex
struct CartResponse: Codable {
    let status: String
    let isError: Bool
    let data: CartData
}

// MARK: - CartResponse
struct CartData: Codable {
    let products: [CartProduct]
    let orderInfo: OrderInfo

    enum CodingKeys: String, CodingKey {
        case products
        case orderInfo = "order_info"
    }
}

// MARK: - OrderInfo
struct OrderInfo: Codable {
    let subTotal, shippingCost, total: Int

    enum CodingKeys: String, CodingKey {
        case subTotal = "sub_total"
        case shippingCost = "shipping_cost"
        case total
    }
}

// MARK: - Product
struct CartProduct: Codable {
    let id: Int
    let productName: String
    let imageURL: String
    let price: Int
    let brandName: String
    let quantity: Int
    let size: String

    enum CodingKeys: String, CodingKey {
        case id
        case productName = "product_name"
        case imageURL = "image_url"
        case price
        case brandName = "brand_name"
        case quantity, size
    }
}
// MARK: - Add Carts
struct CartResponseAdd: Codable {
    let status: String
    let isError: Bool
    let data: CartDataAdd
}

// MARK: - Add Carts Data
struct CartDataAdd: Codable {
    let userID, productID, sizeID, quantity: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case productID = "product_id"
        case sizeID = "size_id"
        case quantity
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
