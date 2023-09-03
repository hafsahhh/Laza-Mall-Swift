//
//  PaymentModel.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 02/09/23.
//

import Foundation
struct CreditCard : Codable {
    var cardOwner : String = ""
    var carNumber : String = ""
    var cardExp : String = ""
    var cardCvv : String = ""
}
