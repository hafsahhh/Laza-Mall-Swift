//
//  ApiCall.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 23/08/23.
//

import Foundation

struct API {
    static let baseUrl = "https://lazaapp.shop/"
}

protocol Endpoint {
    var url: String { get }
}

enum Endpoints {
    enum Gets: Endpoint {
        case login
        case register
        case forgotPassword
        case codeForgot
        case newPassword(email: String, code: String)
        case profile
        case productAll
        case producDetail(id: Int)
        case riview(id: Int)
        case brandAll
        case brandProduct(nameBrand: String)
        case addWishList(idProduct: Int)
        case wishlistAll
        case cartsAll
        case addCarts(idProduct: Int, idSize: Int)
        case deleteCarts(idProduct: Int, idSize: Int)
        case sizeAll
        public var url: String {
            switch self {
            case .login:
                return "\(API.baseUrl)login"
            case .register:
                return "\(API.baseUrl)register"
            case .forgotPassword:
                return "\(API.baseUrl)auth/forgotpassword"
            case .codeForgot:
                return "\(API.baseUrl)auth/recover/code"
            case .newPassword(email: let email, code: let code):
                return "\(API.baseUrl)auth/recover/password?email=\(email)&code=\(code)"
            case .profile:
                return "\(API.baseUrl)user/profile"
            case .producDetail(id: let id):
                return "\(API.baseUrl)products/\(id)"
            case .productAll:
                return"\(API.baseUrl)products"
            case .brandAll:
                return"\(API.baseUrl)brand"
            case .riview(id: let id):
                return "\(API.baseUrl)products/\(id)/reviews"
            case .brandProduct(nameBrand: let nameBrand):
                return "\(API.baseUrl)products/brand?name=\(nameBrand)"
            case .addWishList(idProduct: let idProduct):
                return "\(API.baseUrl)wishlists?ProductId=\(idProduct)"
            case .wishlistAll:
                return"\(API.baseUrl)wishlists"
            case .cartsAll:
                return"\(API.baseUrl)carts"
            case .addCarts(idProduct: let idProduct, idSize: let idSize):
                return "\(API.baseUrl)carts?ProductId=\(idProduct)&SizeId=\(idSize)"
            case .deleteCarts(idProduct: let idProduct, idSize: let idSize):
                return "\(API.baseUrl)carts?ProductId=\(idProduct)&SizeId=\(idSize)"
            case .sizeAll:
                return "\(API.baseUrl)size"
            }
        }
    }
}
