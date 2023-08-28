//
//  VerifyEmailVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 27/08/23.
//

import UIKit

class VerifyEmailVC: UIViewController {

    @IBOutlet weak var emailAddressView: UITextField!
    @IBOutlet weak var verifyEmailBtnView: UIButton!
    
    let verifyEmailViewModel = VerifyEmailViewModel()
    
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

        //back button
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem  = backBarBtn
        
        verifyEmailBtnView.isEnabled = false
        
        emailAddressView.addTarget(self, action:  #selector(cekValidasi),  for:.editingChanged )
        
    }
    
    // MARK: - Func Validasi
    //membuat fungsi untuk cekvalidasi email dan password
    @objc private func cekValidasi(){
        let isEmailValid =
        //validasi email [validEmail] di folder extensions
        emailAddressView.validEmail(emailAddressView.text ?? "")
        
        //jika email dan password valid maka button akan berwarna biru
        if isEmailValid {
            verifyEmailBtnView.isEnabled = true
            verifyEmailBtnView.backgroundColor = UIColor(named: "ColorBg" )
            verifyEmailBtnView.tintColor = UIColor(named: "ColorWhite")
        } else {
            verifyEmailBtnView.isEnabled = false
            verifyEmailBtnView.backgroundColor = UIColor(named: "ColorDarkValid" )
        }
    }
    
    // MARK: - Func getPassEmail
    // Panggil Func getPassEmail
    func verifyEmailApi() {
        let email = emailAddressView.text ?? ""
        verifyEmailViewModel.sendVeifyEmail (email: email) { result in
            switch result {
            case .success :
                DispatchQueue.main.async {
                    ShowAlert.performAlertApi(on: self, title: "Successfully", message: "Please check your email and click the verify account link")
                    self.loginVc()
                }
                
            case .failure(let error):
                self.verifyEmailViewModel.apiVerifyEmail = { description in
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
    
    //untuk jump to login view controller
    func loginVc(){
        let verifiyEmail = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        verifiyEmail.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(verifiyEmail, animated: true)
    }
    
    @IBAction func verifyEmailBtn(_ sender: UIButton) {
        
        verifyEmailApi()
    }
    
}
