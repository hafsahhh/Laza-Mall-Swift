//
//  NewPasswordVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 26/07/23.
//

import UIKit

class NewPasswordVC: UIViewController {
    
    @IBOutlet weak var newPasswordOutlet: UITextField!{
        didSet{
            newPasswordOutlet.addShadow(color: .gray, width: 0.5, text: newPasswordOutlet)
        }
    }
    @IBOutlet weak var confirmPassOutlet: UITextField!{
        didSet{
            confirmPassOutlet.addShadow(color: .gray, width: 0.5, text: confirmPassOutlet)
        }
    }
    @IBOutlet weak var resetPassOutlet: UIButton!
    
    var iconClick = true
    var isNewPassValid = false
    var isConfirmPassValid = false
    
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
        resetPassOutlet.isEnabled = false
        newPasswordOutlet.isSecureTextEntry = true
        confirmPassOutlet.isSecureTextEntry = true
        confirmPassOutlet.addTarget(self, action:  #selector(textFieldDidChange),  for:.editingChanged )
        newPasswordOutlet.addTarget(self, action:  #selector(textFieldDidChange),  for:.editingChanged )
        
        // Do any additional setup after loading the view.
    }
    
    
    //fungsi untuk mengubah button backgournd color
    @objc func textFieldDidChange() {
        //validasi email [validEmail] di folder extensions
        isNewPassValid = newPasswordOutlet.validPassword(newPasswordOutlet.text ?? "")
        //validasi password [validPassword] di folder extensions
        isConfirmPassValid = confirmPassOutlet.validPassword(confirmPassOutlet.text ?? "")
        
        if isNewPassValid || isConfirmPassValid {
            resetPassOutlet.isEnabled = false
            resetPassOutlet.backgroundColor = UIColor(named: "ColorValid" )
        }else{
            resetPassOutlet.isEnabled = true
            resetPassOutlet.backgroundColor = UIColor(named: "ColorBg" )
        }
    }
    
    // MARK: - Func Validasi Updatse Pass
    @objc func validasiUpdatePass() {
        //validasi email [validEmail] di folder extensions
        isNewPassValid = newPasswordOutlet.validPassword(newPasswordOutlet.text ?? "")
        //validasi password [validPassword] di folder extensions
        isConfirmPassValid = confirmPassOutlet.validPassword(confirmPassOutlet.text ?? "")
        
        if isNewPassValid == isConfirmPassValid {
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
    
    func eyeBtn (){
        if iconClick {
            iconClick = true
            newPasswordOutlet.isSecureTextEntry = false
        } else {
            iconClick = false
            newPasswordOutlet.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    
    @IBAction func eyePassBtn(_ sender: Any) {
        if iconClick {
            iconClick = true
            newPasswordOutlet.isSecureTextEntry = false
        } else {
            iconClick = false
            newPasswordOutlet.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    
    @IBAction func eyeConfrimPaaBtn(_ sender: Any) {
        if iconClick {
            iconClick = true
            confirmPassOutlet.isSecureTextEntry = false
        } else {
            iconClick = false
            confirmPassOutlet.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    
    // MARK: - Reset Password Button
    @IBAction func resetPassBtnAct(_ sender: Any) {
        validasiUpdatePass()
    }
    
    
}
