//
//  ForgotPasswordVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 25/07/23.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var forgotPassOutlet: UIButton!
    
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
        } else {
            forgotPassOutlet.isEnabled = false
            forgotPassOutlet.backgroundColor = UIColor(named: "ColorValid" )
        }
        
    }
    
    // Panggil fungsi getData dari kelas UserAllApi untuk cek data email ada atau tidak
    func loginAndGetData(email: String) {

        UserAllApi().getData { userIndex in
            // Lakukan pengecekan apakah ada user dengan username dan password yang sesuai dalam data userIndex
            let matchingUser = userIndex.first { user in
                user.email == email
            }
            
            if let user = matchingUser {
                // Login berhasil, tampilkan pesan sukses atau navigasi ke halaman berikutnya
                print("Login berhasil, user: \(user)")
                DispatchQueue.main.async {
                    self.newPasswordVC()
                }
            } else {
                // email salah, update paswword gagal
                print("Update password gagal, email salah")
            }
        }
    }
    
    //untuk jump to new password view controller
    func newPasswordVC(){
        let newPassVc = self.storyboard?.instantiateViewController(withIdentifier: "NewPasswordVC") as! NewPasswordVC
        newPassVc.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(newPassVc, animated: true)
    }
    
    // MARK: - Forgot Password Button
    @IBAction func forgotPassBtnAct(_ sender: Any) {
        guard let email = emailOutlet.text else {
            return
        }
        // Panggil fungsi untuk melakukan login dan mendapatkan data user
        loginAndGetData(email: email)
        
    }
    

}
