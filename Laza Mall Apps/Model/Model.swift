//
//  Model.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 26/07/23.
//

import Foundation


struct ProductIndex : Codable{
    var results: [ProductEntry]!
}

struct ProductEntry : Codable{
    let title : String
    let image : String
    let price : Double
    let category : Category
}
 
struct categoryIndex : Codable{
    var results: [categoryEntry]!
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
    var name : Name
    var username : String
    var email : String
    var phone : String
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
