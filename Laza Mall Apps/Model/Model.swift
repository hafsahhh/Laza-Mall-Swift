//
//  Model.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 26/07/23.
//

import Foundation

//typealias Categoriess = [String]

struct ProductIndex : Codable{
    var results: [ProductEntry]!
}

struct ProductEntry : Codable{
    let title : String
    let image : String
    let price : Double
    let category : Category
    let description: String
    let rating: Rating
}
 
struct Rating: Codable {
    let rate: Double
    let count: Int
}


struct categoryEntry : Codable{
    let category : Category
}
enum Category: String, Codable {
    case electronics = "electronics"
    case jewelery = "jewelery"
    case menSClothing = "men's clothing"
    case womenSClothing = "women's clothing"
}

struct ProductDetail : Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
}


struct userIndex : Codable{
    var results: [allUser]!
}

struct allUser : Codable {
//    var name : Name
    var username : String
    var email : String
//    var phone : String
    var password : String
//    var address : Address
//    var id : Int
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
