//
//  ForgotPasswordVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 25/07/23.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var emailOutlet: UITextField!{
        didSet{
            emailOutlet.addShadow(color: .gray, width: 0.5, text: emailOutlet)
        }
    }
    @IBOutlet weak var forgotPassOutlet: UIButton!
    
    let forgotPassViewModel = ForgotPasswordViewModel()
    
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
        
        emailOutlet.addTarget(self, action:  #selector(cekValidasi),  for:.editingChanged )
    }
    //membuat fungsi untuk cekvalidasi email dan password
    @objc private func cekValidasi(){
        let isEmailValid =
        //validasi email [validEmail] di folder extensions
        emailOutlet.validEmail(emailOutlet.text ?? "")
        
        //jika email dan password valid maka button akan berwarna biru
        if isEmailValid {
            forgotPassOutlet.isEnabled = true
            forgotPassOutlet.backgroundColor = UIColor(named: "ColorBg" )
            forgotPassOutlet.tintColor = UIColor(named: "ColorWhite")
        } else {
            forgotPassOutlet.isEnabled = false
            forgotPassOutlet.backgroundColor = UIColor(named: "ColorDarkValid" )
        }
        
    }
    
    
    // MARK: - Func getPassEmail
    // Panggil Func getPassEmail
    func forgotPasswordApi() {
        let email = emailOutlet.text ?? ""
        forgotPassViewModel.getPassEmail(email: email) { result in
            switch result {
            case .success(let json):
                // Panggil metode untuk berpindah ke view controller selanjutnya
                self.forgotPassViewModel.succesAlerForgotPass = { successMessage in
                    DispatchQueue.main.async {
                        self.verificationCodeVC()
                        ShowAlert.forgotPassApi(on: self, title: "Notification", message: successMessage)
                    }
                }
                print("Response JSON: \(String(describing: json))")
            case .failure(let error):
                self.forgotPassViewModel.failedApiAlertForgotPassword = { description in
                    DispatchQueue.main.async {
                        print("Alert showing for failure case - errorMessage: \(description)")
                        ShowAlert.forgotPassApi(on: self, title: "Error Message", message: description)
                    }
                }
                print("Error: \(error)")
                // Handle error appropriately
            }
        }
    }
    
    //untuk jump to new password view controller
    func verificationCodeVC(){
        let verifCodeVc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyCodeVC") as! VerifyCodeVC
        verifCodeVc.userEmail = emailOutlet.text
        verifCodeVc.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(verifCodeVc, animated: true)
    }
    
    
    // MARK: - Forgot Password Button
    @IBAction func forgotPassBtnAct(_ sender: Any) {
        forgotPasswordApi()
    }
    
    
}
