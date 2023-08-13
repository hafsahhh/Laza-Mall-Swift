//
//  CheckoutVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 07/08/23.
//

import UIKit

class CheckoutVC: UIViewController {

    
    @IBOutlet weak var goToOrder: UIButton!{
        didSet{
            goToOrder.layer.cornerRadius = 5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToOrderBtn(_ sender: Any) {
      let goToOrderCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as! CartVC
        goToOrderCtrl.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(goToOrderCtrl, animated: true)
    }
    
    
    @IBAction func continueShopBtn(_ sender: Any) {
        let continueShopCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNestedVC") as! HomeNestedVC
        continueShopCtrl.navigationItem.hidesBackButton = true
          self.navigationController?.pushViewController(continueShopCtrl, animated: true)
    }
}
