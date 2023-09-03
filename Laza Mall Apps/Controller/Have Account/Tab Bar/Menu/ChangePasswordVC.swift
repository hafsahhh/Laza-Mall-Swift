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
    var isNewPassValid = false
    var isConfirmPassValid = false
    let changePasswordViewModel = ChangePasswordViewModel()
    
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
        
        changePassView.isEnabled = false
        oldPassView.isSecureTextEntry = true
        newPassView.isSecureTextEntry = true
        confirmPassView.isSecureTextEntry = true
        
        newPassView.addTarget(self, action: #selector(validasiUpdatePass), for: .editingChanged)
        confirmPassView.addTarget(self, action: #selector(validasiUpdatePass), for: .editingChanged)
    }
    
    // MARK: - Func Validasi Update Pass
    @objc func validasiUpdatePass() {
        // Validasi password di folder extensions
        isNewPassValid = newPassView.validPassword(newPassView.text ?? "")
        // Validasi password [validPassword] di folder extensions
        isConfirmPassValid = confirmPassView.validPassword(confirmPassView.text ?? "")
        
        if isNewPassValid && isConfirmPassValid && !confirmPassView.text!.isEmpty {
            if newPassView.text == confirmPassView.text {
                // Jika kedua kata sandi valid dan sesuai, aktifkan tombol
                changePassView.isEnabled = true
                changePassView.backgroundColor = UIColor(named: "ColorBg" )
                changePassView.tintColor = UIColor(named: "ColorWhite")
            } else {
                // Jika kata sandi tidak sesuai, nonaktifkan tombol dan tampilkan pesan kesalahan
                changePassView.isEnabled = false
                changePassView.backgroundColor = UIColor(named: "ColorDarkValid" )
                print("Passwords do not match")
                // create the alert
                let alert = UIAlertController(title: "Passwords Don't Match", message: "New password and confirm password must match.", preferredStyle: .alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            // Jika tidak valid atau textfield konfirmasi kata sandi kosong, nonaktifkan tombol dan hapus pesan kesalahan jika ada
            changePassView.isEnabled = false
            changePassView.backgroundColor = UIColor(named: "ColorDarkValid" )
            // Hapus pesan kesalahan jika ada
        }
    }

    
    // MARK: - Func change password
    // Panggil Func change password view model
    func putChangePassword() {
        let oldPassword = oldPassView.text ?? ""
        let newPassword = newPassView.text ?? ""
        let confirmNewPassword = confirmPassView.text ?? ""
        changePasswordViewModel.getPassEmail(oldPassword: oldPassword, newPassword: newPassword, confirmNewPassword: confirmNewPassword) { result in
            switch result {
            case .success(let json):
                // Panggil metode untuk berpindah ke view controller selanjutnya
                self.changePasswordViewModel.alertChangePassword = { successMessage in
                    DispatchQueue.main.async {
                        ShowAlert.performAlertApi(on: self, title: "Notification", message: successMessage)
                    }
                }
                print("Response JSON: \(String(describing: json))")
            case .failure(let error):
                self.changePasswordViewModel.alertChangePassword = { description in
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
        putChangePassword()
    }
    
    
}
