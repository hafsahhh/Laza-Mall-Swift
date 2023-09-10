//
//  CheckoutVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 07/08/23.
//

import UIKit

protocol checkoutProtocol: AnyObject {
    func goTohome()
    func goToCart()
}


class CheckoutVC: UIViewController {
    
    @IBOutlet weak var goToOrder: UIButton!{
        didSet{
            goToOrder.layer.cornerRadius = 5
        }
    }
    
    weak var delegate: checkoutProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToOrderBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        delegate?.goToCart()
//        self.dismiss(animated: true)
//      let goToOrderCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as! CartVC
//        goToOrderCtrl.navigationItem.hidesBackButton = true
//        self.navigationController?.pushViewController(goToOrderCtrl, animated: true)
    }
    
    
    @IBAction func continueShopBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        delegate?.goTohome()
    }
}
