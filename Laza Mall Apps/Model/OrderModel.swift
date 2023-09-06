//
//  OrderModel.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 04/09/23.
//

import Foundation
// MARK: - ResponseOrder
struct ResponseOrder: Codable {
    let status: String
    let isError: Bool
    let data: DataOrder
}

// MARK: - DataOrder
struct DataOrder: Codable {
    let order: Order
    let paymentMethod: PaymentMethod

    enum CodingKeys: String, CodingKey {
        case order
        case paymentMethod = "payment_method"
    }
}

// MARK: - Order
struct Order: Codable {
    let id: String
    let amount: Int
    let createdAt, updatedAt: String
    let paidAt, expiryDate: Date
    let shippingFee, adminFee: Int
    let orderStatus: String
    let addressID, paymentMethodID: Int

    enum CodingKeys: String, CodingKey {
        case id, amount
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case paidAt = "paid_at"
        case expiryDate = "expiry_date"
        case shippingFee = "shipping_fee"
        case adminFee = "admin_fee"
        case orderStatus = "order_status"
        case addressID = "address_id"
        case paymentMethodID = "payment_method_id"
    }
}

// MARK: - PaymentMethod
struct PaymentMethod: Codable {
    let id: Int
    let paymentMethod, bank, vaNumber: String
    let expiryTime: Date

    enum CodingKeys: String, CodingKey {
        case id
        case paymentMethod = "payment_method"
        case bank
        case vaNumber = "va_number"
        case expiryTime = "expiry_time"
    }
}

struct CheckoutBody: Codable {
    let products: [DataProduct]
    let addressId: Int
    let bank: String
    
    private enum CodingKeys: String, CodingKey {
        case products = "products"
        case addressId = "address_id"
        case bank = "bank"
    }
}

struct DataProduct: Codable {
    let id: Int
    let quantity: Int
}
