//
//  VerifyCodeVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 15/08/23.
//

import UIKit
import DPOTPView

class VerifyCodeVC: UIViewController {
    
    
    @IBOutlet weak var codeVerificText: DPOTPView!
    @IBOutlet weak var confirmCodeView: UIButton!
    
    
    var userEmail: String?
    let verifyCodeViewModel = VerifyPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    // MARK: - Func VerifyApi
    func verifyCodeApi() {
        let codeString = codeVerificText.text ?? ""
        if let userEmail = userEmail {
            verifyCodeViewModel.getCodeVerify(email: userEmail, code: codeString) { result in
                switch result {
                case .success(let json):
                    // Panggil metode untuk berpindah ke view controller selanjutnya
                    DispatchQueue.main.async {
                        self.newPasswordVc()
                    }
                    print("Response JSON: \(String(describing: json))")
                case .failure(let error):
                    self.verifyCodeViewModel.apiVerifyPassAlert = { description in
                        DispatchQueue.main.async {
                            print("Alert showing for failure case - errorMessage: \(description)")
                            ShowAlert.verifyPassApi(on: self, title: "Error Message", message: description)
                        }
                    }
                    print("Error: \(error)")
                    // Handle error appropriately
                }
            }
        }
    }
    
    //untuk jump to new password view controller
    func newPasswordVc(){
        let newPaswordVc = self.storyboard?.instantiateViewController(withIdentifier: "NewPasswordVC") as! NewPasswordVC
        newPaswordVc.navigationItem.hidesBackButton = true
        newPaswordVc.code = codeVerificText.text
        newPaswordVc.email = userEmail
        self.navigationController?.pushViewController(newPaswordVc, animated: true)
    }
    
    @IBAction func confirmCodeBtn(_ sender: Any) {
        verifyCodeApi()
    }
}
