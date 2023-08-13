//
//  Snack Bar.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 10/08/23.
//

import SnackBar
import UIKit
class AppSnackBar: SnackBar {
    
    override var style: SnackBarStyle {
        var style = SnackBarStyle()
        style.background = .lightGray
        style.textColor = .black
        return style
    }
}
