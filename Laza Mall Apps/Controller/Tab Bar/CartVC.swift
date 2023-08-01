//
//  CartVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 31/07/23.
//

import UIKit

class CartVC: UIViewController {

    //wishlist tab bar
    private func setupTabBarText() {
        let label3 = UILabel()
        label3.numberOfLines = 1
        label3.textAlignment = .center
        label3.text = "Cart"
        label3.font = UIFont(name: "inter-Medium", size: 11)
        label3.sizeToFit()
        
        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "colorBg")
        tabBarItem.selectedImage = UIImage(view: label3)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //func tab Bar action
        setupTabBarText()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
