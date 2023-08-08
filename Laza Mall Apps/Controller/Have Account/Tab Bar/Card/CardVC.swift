//
//  CardVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 31/07/23.
//

import UIKit

class CardVC: UIViewController {

    //wishlist card
    private func setupTabBarText() {
        let label4 = UILabel()
        label4.numberOfLines = 1
        label4.textAlignment = .center
        label4.text = "Card"
        label4.font = UIFont(name: "inter-Medium", size: 11)
        label4.sizeToFit()
        
        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "colorBg")
        tabBarItem.selectedImage = UIImage(view: label4)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //func tab Bar action
        setupTabBarText()
    }
    

    // MARK: - Navigation



}
