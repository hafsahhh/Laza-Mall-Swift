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
    var activityIndicator: UIActivityIndicatorView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide back button
        navigationItem.hidesBackButton = true
        
        // Initialize activity indicator
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        // Configure constraints for the activity indicator
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        passwordOutlet.isSecureTextEntry = true
        
        // Add a target to call textFieldDidChange function when the text changes in both text fields.
        usernameOutlet.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordOutlet.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        // Call the textFieldDidChange function manually once to set the initial state of the button.
        textFieldDidChange()
        
        
        //Show userdefault
        getSaveInfo()
        
        // untuk stay ketika sudah login di awal, jadi user defaultnya sudah tersimpan
        if UserDefaults.standard.bool(forKey: "loginTrue"){
            let tabbarVC = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
            tabbarVC.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(tabbarVC, animated: true)
        }
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
    
    private func startLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.view.backgroundColor = UIColor.lightGray
        }
    }

    private func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.view.backgroundColor = UIColor.white
        }
    }
    
    // MARK: - Login Button
    @IBAction func loginBtnAct(_ sender: UIButton) {
        startLoading()
        loginAndGetData()
    }
    
    // MARK: - Func getData dari kelas UserAllApi
    // Panggil fungsi getData dari kelas UserAllApi
    func loginAndGetData() {
        let username = usernameOutlet.text ?? ""
        let password = passwordOutlet.text ?? ""
        
        loginViewModel.getDataLogin(username: username, password: password) { result in
            self.stopLoading()
            switch result {
            case .success:
                // Login berhasil, panggil getUserProfile untuk mendapatkan profil pengguna
                self.loginViewModel.getUserProfile { result in
                    switch result {
                    case .success(let userProfile):
                        print("User ID: \(String(describing: userProfile?.id))")
                        
                        //save id into coredata
                        guard let unwrappedUserProfile = userProfile else { return }
//                        KeychainManager.shared.setCurrentProfile(profile: unwrappedUserProfile)
                        
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
    
    
    // Fungsi untuk mengambil data pengguna dari UserDefaults
    func getSaveInfo(){
        if let savedUsername = UserDefaults.standard.string(forKey: "username"),
           let savedPassword = KeychainManager.shared.getPassword()
        {
            usernameOutlet.text = savedUsername
            passwordOutlet.text = savedPassword
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
        guard let username = usernameOutlet.text else { return }
        guard let password = passwordOutlet.text else { return }
        
        if (sender as AnyObject).isOn {
            UserDefaults.standard.set(username, forKey: "username")
            KeychainManager.shared.savePassword(token: password)
        } else {
            UserDefaults.standard.removeObject(forKey: "username")
            KeychainManager.shared.deletePassword()
            print("User data removed from UserDefaults.")
        }
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        let createAccountBtn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(createAccountBtn, animated: true)
    }
    
    
}
