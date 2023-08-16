//
//  Model.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 26/07/23.
//

import Foundation
import UIKit


// MARK: - All Product
typealias ProductIndex = ProductResponse?
struct ProductResponse: Codable{
    let status: String
    let isError: Bool
    let data: [ProductEntry]!
}
struct ProductEntry : Codable {
    let id : Int
    let name : String
    let image_url : String
    let price : Double
//    let category : Category
//    let description: String
//    let rating: Rating
    
    private enum CodingKeys: String, CodingKey {
        case id, name, price
        case image_url = "image_url"
    }
}
 

// MARK: - Brand Product
typealias categoryIndex = categoryResponse?
struct categoryResponse: Codable{
    let status: String
    let isError: Bool
    let description: [categoryEntry]
}
struct categoryEntry : Codable{
    let id : Int
    let name : String
    let logo_url : String
}

struct ProductDetail : Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
}

// MARK: - User
struct userEntry: Codable {
    let status: String
    let isError: Bool
    let data: DataUser
}

// MARK: - DataClass
struct DataUser: Codable {
    let id: Int
    let fullName, username, email: String
    let isVerified: Bool
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case username, email
        case isVerified = "is_verified"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


// MARK: - User
typealias UserIndex = [allUser]
struct userIndex : Codable{
    var results: [allUser]!
}

struct allUser : Codable {
//    var full_name : String
    var username : String
    var email : String
    var password : String

}

struct Name : Codable {
    var firstname : String
    var lastname : String
}



// MARK: - Address
struct Address: Codable {
    let geolocation: Geolocation
    let city, street: String
    let number: Int
    let zipcode: String
}

// MARK: - Geolocation
struct Geolocation: Codable {
    let lat, long: String
}

struct userDefault : Codable {
    var firstName : String
    var lastName : String
    var username : String
    var email : String
    var phoneNo : String
    var password : String
}
// MARK: - CartElement
struct CartElement: Codable {
    let id, userID: Int
    let date: String
    let products: [Product]
    let v: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case date, products
        case v = "__v"
    }
}

// MARK: - Product
struct Product: Codable {
    let productID : Int
    let quantity : Int
    enum CodingKeys: String, CodingKey {
        case productID = "productId"
        case quantity
    }
}

struct CartProd: Codable {
    let productID : Int
    let quantity : Int
}

// MARK: - Review
typealias cellUserReviews = [userReviews]
struct userReviews{
    var name: String
    var userImage: UIImage
    var textReviews: String
    var rating: String
    var time: String
}


// MARK: - Address
typealias cellListAddressUser = [listAddressUser]
struct listAddressUser{
    var nameUser: String
    var numberHandphone: String
    var countryUser: String
    var cityUser: String
    var fulladdress: String
}

// MARK: - Wishlist
typealias indexWishlist = [wishlist]
struct wishlist {
    var name: String
    var image_url: String
    var price: Float
    var brand_name: String
}

// MARK: - Credit Card
typealias indexCreditCard = [creditCard]
struct creditCard {
    var card_number: String
    var expired_month: Int
    var expired_year: Int
    var user_id: Int
}

