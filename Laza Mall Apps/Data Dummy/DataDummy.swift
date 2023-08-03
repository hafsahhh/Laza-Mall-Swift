//
//  DataDummy.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 03/08/23.
//

import Foundation
import UIKit

struct userReviews{
    var name: String
    var userImage: UIImage
    var textReviews: String
    var rating: String
    var time: String
}


var cellUserReviews : [userReviews] = [
    userReviews(name: "Jenny Wilson", userImage: UIImage(named: "JennyWilson")!, textReviews: "StringLorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque malesuada eget vitae amet...", rating: "4.8", time: "13 Sep, 2020"),
    userReviews(name: "Ronald Richards", userImage: UIImage(named: "RonaldRichards")!, textReviews: "StringLorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque malesuada eget vitae amet...", rating: "4.8", time: "13 Sep, 2020"),
    userReviews(name: "Guy Hawkins", userImage: UIImage(named: "GuyHawkins")!, textReviews: "StringLorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque malesuada eget vitae amet...", rating: "4.8", time: "13 Sep, 2020"),
    userReviews(name: "Savannah Nguyen", userImage: UIImage(named: "SavannahNguyen")!, textReviews: "StringLorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque malesuada eget vitae amet...", rating: "4.8", time: "13 Sep, 2020")
]
