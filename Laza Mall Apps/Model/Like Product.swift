//
//  Like Product.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 06/08/23.
//

import Foundation
import UIKit


struct likeProductWhishlist: Codable, Equatable {
    var imageWhishlistProd: String = ""
    var titleWhishlistProd: String = ""
    var priceWhislistProd: Int16 = 0
}

//Equatable adalah sebuah protokol (protocol) di Swift yang digunakan untuk memungkinkan objek agar bisa dibandingkan (compared) dengan objek lain untuk keperluan kesamaan (equality). 
