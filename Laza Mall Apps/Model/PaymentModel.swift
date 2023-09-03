//
//  PaymentModel.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 02/09/23.
//

import Foundation
struct CreditCard : Codable {
    var cardOwner : String = ""
    var cardNumber : String = ""
//    var cardExp : String = ""
    var cardExpMonth : String = ""
    var cardExpYear : String = ""
    var cardCvv : String = ""
}
