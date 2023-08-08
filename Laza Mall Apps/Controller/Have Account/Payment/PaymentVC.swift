//
//  PaymentVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 07/08/23.
//

import UIKit

class PaymentVC: UIViewController {

    //Back Button
    private lazy var backBtn : UIButton = {
        //call back button
        let backBtn = UIButton.init(type: .custom)
        backBtn.setImage(UIImage(named:"Back"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        backBtn.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        

        return backBtn
    }()

    //Back Button
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        let backBarBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem  = backBarBtn
    }
    
    @IBAction func addNewCartBtn(_ sender: Any) {
        let addCardBtn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        self.navigationController?.pushViewController(addCardBtn, animated: true)
    }
    
}
