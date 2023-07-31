//
//  NewPasswordVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 26/07/23.
//

import UIKit

class NewPasswordVC: UIViewController {
    
    @IBOutlet weak var newPasswordOutlet: UITextField!
    @IBOutlet weak var confirmPassOutlet: UITextField!
    @IBOutlet weak var resetPassOutlet: UIButton!
    
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
        resetPassOutlet.isEnabled = false
        newPasswordOutlet.isSecureTextEntry = true
        confirmPassOutlet.addTarget(self, action:  #selector(textFieldDidChange),  for:.editingChanged )
        newPasswordOutlet.addTarget(self, action:  #selector(textFieldDidChange),  for:.editingChanged )
        
        // Do any additional setup after loading the view.
    }
    
    
    //fungsi untuk mengubah button backgournd color
    @objc func textFieldDidChange() {
        if newPasswordOutlet.text == "" || confirmPassOutlet.text == "" {
            resetPassOutlet.isEnabled = false
            resetPassOutlet.backgroundColor = UIColor(named: "ColorValid" )
        }else{
            resetPassOutlet.isEnabled = true
            resetPassOutlet.backgroundColor = UIColor(named: "ColorBg" )
        }
    }
    
    
    @objc func validasiUpdatePass() {
        if newPasswordOutlet.text == confirmPassOutlet.text{
            let saveUpdatepassctrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
            saveUpdatepassctrl.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(saveUpdatepassctrl, animated: true)
            
            
        } else {
            resetPassOutlet.isEnabled = false
            resetPassOutlet.backgroundColor = UIColor(named: "ColorValid" )
            print("wrong password")
            // create the alert
            let alert = UIAlertController(title: "Wrong Password", message: "Please try another password.", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Reset Password Button
    @IBAction func resetPassBtnAct(_ sender: Any) {
        validasiUpdatePass()
    }
    
    
}
