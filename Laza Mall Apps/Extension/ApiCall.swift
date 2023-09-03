//
//  ApiCall.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 23/08/23.
//

import Foundation


struct API {
    static func APIAddress(isMockApi: Bool) -> String {
        let baseUrl = isMockApi ? "http://localhost:3002/" : "https://lazaapp.shop/"
        return baseUrl
    }
//    static let baseUrl = "https://lazaapp.shop/"
}

protocol Endpoint {
    var url: String { get }
}

enum Endpoints {
    enum Gets: Endpoint {
        case login
        case register
        case verifyEmail
        case forgotPassword
        case codeForgot
        case newPassword(email: String, code: String)
        case profile
        case updateProfile
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
        case updateCarts(idProduct: Int, idSize: Int)
        case sizeAll
        case addressAll
        case addAddress
        case updateAddresss(idAddress: Int)
        case deleteAddress(idAddress: Int)
        case changePassword
        case refreshToken
        public var url: String {
            switch self {
            case .login:
                return "\(API.APIAddress(isMockApi: false))login"
            case .register:
                return "\(API.APIAddress(isMockApi: false))register"
            case .verifyEmail:
                return "\(API.APIAddress(isMockApi: false))auth/confirm/resend"
            case .forgotPassword:
                return "\(API.APIAddress(isMockApi: false))auth/forgotpassword"
            case .codeForgot:
                return "\(API.APIAddress(isMockApi: false))auth/recover/code"
            case .newPassword(email: let email, code: let code):
                return "\(API.APIAddress(isMockApi: false))auth/recover/password?email=\(email)&code=\(code)"
            case .profile:
                return "\(API.APIAddress(isMockApi: false))user/profile"
            case .updateProfile:
                return "\(API.APIAddress(isMockApi: false))user/update"
            case .producDetail(id: let id):
                return "\(API.APIAddress(isMockApi: false))products/\(id)"
            case .productAll:
                return"\(API.APIAddress(isMockApi: false))products"
            case .brandAll:
                return"\(API.APIAddress(isMockApi: false))brand"
            case .riview(id: let id):
                return "\(API.APIAddress(isMockApi: false))products/\(id)/reviews"
            case .brandProduct(nameBrand: let nameBrand):
                return "\(API.APIAddress(isMockApi: false))products/brand?name=\(nameBrand)"
            case .addWishList(idProduct: let idProduct):
                return "\(API.APIAddress(isMockApi: false))wishlists?ProductId=\(idProduct)"
            case .wishlistAll:
                return"\(API.APIAddress(isMockApi: false))wishlists"
            case .cartsAll:
                return"\(API.APIAddress(isMockApi: false))carts"
            case .addCarts(idProduct: let idProduct, idSize: let idSize):
                return "\(API.APIAddress(isMockApi: false))carts?ProductId=\(idProduct)&SizeId=\(idSize)"
            case .deleteCarts(idProduct: let idProduct, idSize: let idSize):
                return "\(API.APIAddress(isMockApi: false))carts?ProductId=\(idProduct)&SizeId=\(idSize)"
            case .sizeAll:
                return "\(API.APIAddress(isMockApi: false))size"
            case .updateCarts(idProduct: let idProduct, idSize: let idSize):
                return "\(API.APIAddress(isMockApi: false))carts?ProductId=\(idProduct)&SizeId=\(idSize)"
            case .addressAll:
                return "\(API.APIAddress(isMockApi: false))address"
            case .addAddress:
                return "\(API.APIAddress(isMockApi: false))address"
            case .updateAddresss (idAddress: let idAddress):
                return "\(API.APIAddress(isMockApi: false))address/\(idAddress)"
            case .deleteAddress (idAddress: let idAddress):
                return "\(API.APIAddress(isMockApi: false))address/\(idAddress)"
            case .changePassword:
                return "\(API.APIAddress(isMockApi: false))user/change-password"
            case .refreshToken:
                return "\(API.APIAddress(isMockApi: false))auth/refresh"
            }
        }
    }
}
