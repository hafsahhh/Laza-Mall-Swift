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
    var cardExpMonth : Int16 = 0
    var cardExpYear : Int16 = 0
    var cardCvv : Int16 = 0
    var userId : Int32 = 0
}
