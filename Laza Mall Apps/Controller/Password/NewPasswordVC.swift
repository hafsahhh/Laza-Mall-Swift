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
    var email: String?
    var code: String?
    let newPassViewModel = NewPasswordViewModel()
    
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
        confirmPassOutlet.addTarget(self, action:  #selector(validasiUpdatePass),  for:.editingChanged )
        newPasswordOutlet.addTarget(self, action:  #selector(validasiUpdatePass),  for:.editingChanged )
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Func Validasi Updatse Pass
    @objc func validasiUpdatePass() {
        //validasi email [validEmail] di folder extensions
        isNewPassValid = newPasswordOutlet.validPassword(newPasswordOutlet.text ?? "")
        //validasi password [validPassword] di folder extensions
        isConfirmPassValid = confirmPassOutlet.validPassword(confirmPassOutlet.text ?? "")
        
        if isNewPassValid == isConfirmPassValid {
            resetPassOutlet.isEnabled = true
            resetPassOutlet.backgroundColor = UIColor(named: "ColorBg" )
            resetPassOutlet.tintColor = UIColor(named: "ColorWhite")
        } else {
            resetPassOutlet.isEnabled = false
            resetPassOutlet.backgroundColor = UIColor(named: "ColorDarkValid" )
            print("wrong password")
            // create the alert
            let alert = UIAlertController(title: "Wrong Password", message: "Please try the same password.", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Func getData dari kelas UserAllApi
    // Panggil fungsi getData dari kelas UserAllApi
    func newPassword() {
        let newPassword = newPasswordOutlet.text ?? ""
        let rePassword = confirmPassOutlet.text ?? ""
        guard let userEmail = email else { return }
        guard let userCode = code else {return}
        newPassViewModel.getCodeVerify(newPassword: newPassword, rePassword: rePassword, email: userEmail, code: userCode) { result in
            switch result {
            case .success(let json):
                // Panggil metode untuk berpindah ke view controller selanjutnya
                DispatchQueue.main.async {
                    self.verificationCodeVC()
                }
                print("Response JSON: \(String(describing: json))")
            case .failure(let error):
                print("Error: \(error)")
                // Handle error appropriately
            }
        }
    }
    
    //untuk jump to new password view controller
    func verificationCodeVC(){
        let verifCodeVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        verifCodeVc.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(verifCodeVc, animated: true)
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
        newPassword()
    }
    
    
}
