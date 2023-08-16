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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // MARK: - Func getData dari kelas UserAllApi
    // Panggil fungsi getData dari kelas UserAllApi
    func verifyCodeApi() {
        let codeString = codeVerificText.text ?? ""
        if let userEmail = userEmail { 
            ApiVerifyPassCode().getCodeVerify(email: userEmail, code: codeString) { result in
                switch result {
                case .success(let json):
                    // Panggil metode untuk berpindah ke view controller selanjutnya
                    DispatchQueue.main.async {
                        self.verifyCodeVC()
                    }
                    print("Response JSON: \(String(describing: json))")
                case .failure(let error):
                    print("Error: \(error)")
                    // Handle error appropriately
                }
            }
        } else {
            print("Invalid code format")
        }
    }

    
    //untuk jump to new password view controller
    func
    verifyCodeVC(){
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
