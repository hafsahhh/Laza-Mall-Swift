//
//  LoginVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 25/07/23.
//

import UIKit

class LoginVC: UIViewController {
    
    
    @IBOutlet weak var usernameOutlet: UITextField!{
        didSet{
            usernameOutlet.addShadow(color: .gray, width: 0.5, text: usernameOutlet)
        }
    }
    @IBOutlet weak var passwordOutlet: UITextField! {
        didSet{
            passwordOutlet.addShadow(color: .gray, width: 0.5, text: passwordOutlet)
        }
    }
    @IBOutlet weak var loginBtnOutlet: UIButton!
    @IBOutlet weak var saveUserLoginOutlet: UISwitch!
    
    @IBOutlet weak var ceklisUsername: UIImageView!{
        didSet {
            ceklisUsername.isHidden = true
        }
    }
    
    @IBOutlet weak var cekStrongPassValid: UILabel!{
        didSet {
            cekStrongPassValid.isHidden = true
        }
    }
    
    let userDefault = UserDefaults.standard
    let saveDataLogin = "saveDataLogin"
    let loginTrue = "loginTrue"
    let loginViewModel = LoginViewModel()
    var iconClick = true
    var isUsernameValid = false
    var isPasswordValid = false
    
    
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
        
        passwordOutlet.isSecureTextEntry = true
        
        // Add a target to call textFieldDidChange function when the text changes in both text fields.
        usernameOutlet.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordOutlet.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        // Call the textFieldDidChange function manually once to set the initial state of the button.
        textFieldDidChange()
        
        //load user default
        loadUserData()
    }
    
    
    private func checkValidate(){
        let isUsernameNotNull = usernameOutlet.text ?? ""
        isUsernameValid = isUsernameNotNull.count > 4
        if isUsernameValid {
            ceklisUsername.isHidden = false
        } else {
            ceklisUsername.isHidden = true
        }
        
        isPasswordValid = passwordOutlet.validPassword(passwordOutlet.text ?? "")
        if isPasswordValid {
            cekStrongPassValid.isHidden = false
        } else {
            cekStrongPassValid.isHidden = true
        }
        
    }
    
    // Mengubah warna pada button
    @objc func textFieldDidChange() {
        checkValidate()
        if usernameOutlet.hasText && passwordOutlet.hasText {
            loginBtnOutlet.isEnabled = true
            loginBtnOutlet.backgroundColor = UIColor(named: "ColorBg")
            loginBtnOutlet.tintColor = UIColor(named: "ColorWhite")
        } else {
            loginBtnOutlet.isEnabled = false
            loginBtnOutlet.backgroundColor = UIColor(named: "ColorDarkValid")
        }
    }
    
    // MARK: - Login Button
    @IBAction func loginBtnAct(_ sender: UIButton) {
        loginAndGetData()
    }
    
    // MARK: - Func getData dari kelas UserAllApi
    // Panggil fungsi getData dari kelas UserAllApi
    func loginAndGetData() {
        let username = usernameOutlet.text ?? ""
        let password = passwordOutlet.text ?? ""
        
        loginViewModel.getDataLogin(username: username, password: password) { result in
            switch result {
            case .success:
                // Login berhasil, panggil getUserProfile untuk mendapatkan profil pengguna
                self.loginViewModel.getUserProfile { result in
                    switch result {
                    case .success(let userProfile):
                        // Panggil metode untuk berpindah ke view controller selanjutnya
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(true, forKey: "loginTrue")
                            self.tabBarController(userProfile: userProfile)
                        }
                    case .failure(let error):
                        print("Error getting user profile: \(error.localizedDescription)")
                        // Panggil fungsi untuk menampilkan alert login gagal
                        self.loginViewModel.apiAlertLogin?("Error", "Login failed")
                    }
                }
            case .failure(let error):
                self.loginViewModel.apiAlertLogin = { status, description in
                    DispatchQueue.main.async {
                        if description == "please verify your account" {
                            print("ini verify email \(description)")
                            let refreshAlert = UIAlertController(title: "Failed Login", message: "\(description), Send Again Verification Account", preferredStyle: UIAlertController.Style.alert)
                            
                            refreshAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action: UIAlertAction!) in
                                let sendEmailVC = self.storyboard?.instantiateViewController(withIdentifier: "VerifyEmailVC") as! VerifyEmailVC
                                self.navigationController?.pushViewController(sendEmailVC, animated: true)
                            }))
                            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                                refreshAlert .dismiss(animated: true, completion: nil)
                            }))
                            
                            self.present(refreshAlert, animated: true, completion: nil)
                        } else {
                            ShowAlert.signUpApi(on: self, title: "Notification \(status)", message: description)
                        }
                        print("JSON Login Error: \(error)")
                    }
                }
            }
        }
    }
    
    func tabBarController(userProfile: DataUseProfile?){
        let tabbarVC = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
        tabbarVC.userProfile = userProfile
        tabbarVC.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(tabbarVC, animated: true)
    }
    
    
    //fungsi userdefault untuk menyimpan textfield yang sudah terisi
    func saveUserDefault(_ userDetail: allUser){
        // Dengan mengansumsikan memiliki variabel 'saveUserLoginOutlet' yang mewakili tombol sakelar
        if saveUserLoginOutlet.isOn {
            let defaults = UserDefaults.standard
            let encoder = JSONEncoder()
            do {
                let encoded = try encoder.encode(userDetail)
                defaults.set(encoded, forKey: saveDataLogin)
                print("User data saved to UserDefaults.")
            } catch {
                print("Failed to encode user data: \(error.localizedDescription)")
            }
        } else {
            UserDefaults.standard.removeObject(forKey: saveDataLogin)
            print("User data removed from UserDefaults.")
        }
        
    }
    
    //Fungsi untuk membaca user default yang ada di textfield
    func loadUserData() {
        if let savedData = UserDefaults.standard.data(forKey: saveDataLogin) {
            let decoder = JSONDecoder()
            if let userDetail = try? decoder.decode(allUser.self, from: savedData) {
                usernameOutlet.text = userDetail.username
                passwordOutlet.text = userDetail.password
            }
        }
    }
    
    
    // MARK: - eye Password Button
    @IBAction func eyePassBtn(_ sender: Any) {
        if iconClick {
            iconClick = true
            passwordOutlet.isSecureTextEntry = false
        } else {
            iconClick = false
            passwordOutlet.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    
    // MARK: - Forget Password Button
    @IBAction func forgotPassBtnAct(_ sender: Any) {
        let forgotBtnCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(forgotBtnCtrl, animated: true)
    }
    
    
    // MARK: - Switch Button untuk save di userdefault
    @IBAction func saveDataLoginSwitch(_ sender: Any) {
        if (sender as AnyObject).isOn {
            // Call the function here passing the user details to be saved
            let userDetail = allUser(username: usernameOutlet.text ?? "", email: "", password: passwordOutlet.text ?? "")
            saveUserDefault(userDetail)
            UserDefaults.standard.set(true, forKey: loginTrue)
        } else {
            // If the switch is turned off, you can decide what to do here.
            // You might want to remove user data from UserDefaults as you do in the saveUserDefault function.
            UserDefaults.standard.removeObject(forKey: saveDataLogin)
            print("User data removed from UserDefaults.")
        }
    }
    
}
