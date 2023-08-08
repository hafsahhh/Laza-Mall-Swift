//
//  VerificationCodeVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 03/08/23.
//

import UIKit

class VerificationCodeVC: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem  = backBarBtn
        
        
    }
    
    //untuk jump to new password view controller
    func newPasswordVC(){
        let newPassVc = self.storyboard?.instantiateViewController(withIdentifier: "NewPasswordVC") as! NewPasswordVC
        newPassVc.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(newPassVc, animated: true)
    }
    
    @IBAction func confirmPassBtn(_ sender: Any) {
        
        newPasswordVC()
    }
    
}
