//
//  ChangePasswordVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 31/08/23.
//

import UIKit

class ChangePasswordVC: UIViewController {


    @IBOutlet weak var oldPassView: UITextField!{
        didSet{
            oldPassView.addShadow(color: .gray, width: 0.5, text: oldPassView)
        }
    }
    @IBOutlet weak var newPassView: UITextField!{
        didSet{
            newPassView.addShadow(color: .gray, width: 0.5, text: newPassView)
        }
    }
    @IBOutlet weak var confirmPassView: UITextField!{
        didSet{
            confirmPassView.addShadow(color: .gray, width: 0.5, text: confirmPassView)
        }
    }
    
    @IBOutlet weak var changePassView: UIButton!
    
    
    var iconClick = true
    var isOldPassValid = false
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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backBarBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem  = backBarBtn
    }
    
    // MARK: - Func Validasi Updatse Pass
    @objc func validasiUpdatePass() {
        //validasi email [validEmail] di folder extensions
        isNewPassValid = newPassView.validPassword(newPassView.text ?? "")
        //validasi password [validPassword] di folder extensions
        isConfirmPassValid = confirmPassView.validPassword(confirmPassView.text ?? "")
        
        if isNewPassValid == isConfirmPassValid {
            changePassView.isEnabled = true
            changePassView.backgroundColor = UIColor(named: "ColorBg" )
            changePassView.tintColor = UIColor(named: "ColorWhite")
        } else {
            changePassView.isEnabled = false
            changePassView.backgroundColor = UIColor(named: "ColorDarkValid" )
            print("wrong password")
            // create the alert
            let alert = UIAlertController(title: "Wrong Password", message: "Please try the same password.", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    
    @IBAction func eyeOldPassBtn(_ sender: UIButton) {
        if iconClick {
            iconClick = true
            oldPassView.isSecureTextEntry = false
        } else {
            iconClick = false
            oldPassView.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    
    
    @IBAction func eyeNewPassBtn(_ sender: UIButton) {
        if iconClick {
            iconClick = true
            newPassView.isSecureTextEntry = false
        } else {
            iconClick = false
            newPassView.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    
    @IBAction func eyeConfirmBtn(_ sender: UIButton) {
        if iconClick {
            iconClick = true
            confirmPassView.isSecureTextEntry = false
        } else {
            iconClick = false
            confirmPassView.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    
    @IBAction func changePassBtn(_ sender: UIButton) {
        validasiUpdatePass()
        
    }
    
    
}
