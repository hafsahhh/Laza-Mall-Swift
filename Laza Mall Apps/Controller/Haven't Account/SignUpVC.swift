//
//  SignUpVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 25/07/23.
//

import UIKit

class SignUpVC: UIViewController {
    
    
    @IBOutlet weak var usernameOutlet: UITextField!{
        didSet{
            usernameOutlet.addShadow(color: .gray, width: 0.5, text: usernameOutlet)
        }
    }
    @IBOutlet weak var emailOutlet: UITextField!{
        didSet{
            emailOutlet.addShadow(color: .gray, width: 0.5, text: emailOutlet)
        }
    }
    @IBOutlet weak var passwordOutlet: UITextField!{
        didSet{
            passwordOutlet.addShadow(color: .gray, width: 0.5, text: passwordOutlet)
        }
    }
    
    @IBOutlet weak var confirmPassOutlet: UITextField!{
        didSet{
            confirmPassOutlet.addShadow(color: .gray, width: 0.5, text: confirmPassOutlet)
        }
    }
    
    @IBOutlet weak var signUpOutlet: UIButton!
    @IBOutlet weak var saveUserData: UISwitch!
    
    @IBOutlet weak var checkListUsername: UIImageView!{
        didSet {
            checkListUsername.isHidden = true
        }
    }
    @IBOutlet weak var checkListEmail: UIImageView! {
        didSet {
            checkListEmail.isHidden = true
        }
    }
    
    
    @IBOutlet weak var cekStrongPass: UILabel!{
        didSet {
            cekStrongPass.isHidden = true
        }
    }
    
    
    @IBOutlet weak var cekStrongConfirmPass: UILabel!{
        didSet {
            cekStrongConfirmPass.isHidden = true
        }
        
    }
    
    
    //    //key untuk userdefault
    let savedUser = "savedUser"
    let signUpTrue = "signUpTrue"
    let signUpViewModel = SignUpViewModel()
    var iconClick = true
    var isEmailValid = false
    var isUsernameValid = false
    var isPasswordValid = false
    var isConfirmPassValid = false
    var activityIndicator: UIActivityIndicatorView!
    
    
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
    // MARK: - Func viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem  = backBarBtn
        signUpOutlet.isEnabled = false
        passwordOutlet.isSecureTextEntry = true
        confirmPassOutlet.isSecureTextEntry = true
        
        // Initialize activity indicator
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        // Configure constraints for the activity indicator
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Tambahkan target untuk text field untuk melakukan validasi saat text berubah
        usernameOutlet.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailOutlet.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordOutlet.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        confirmPassOutlet.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    
    // MARK: - Func validate with regex
    private func signUpValidate() {
        
        //valid email
        isEmailValid = emailOutlet.validEmail(emailOutlet.text ?? "")
        isPasswordValid = passwordOutlet.validPassword(passwordOutlet.text ?? "")
        let isMatchPassword = passwordOutlet.text == confirmPassOutlet.text
        
        // cek validasi emial dan password
        if !isEmailValid {
            ShowAlert.alertValidEmail(on: self)
        } else if !isPasswordValid {
            ShowAlert.alertValidPassword(on: self)
        } else if !isMatchPassword {
            ShowAlert.passwordDoestMatch(on: self)
        }
    }
    
    // MARK: - Func ceklis validasi
    private func ceklisValidasi(){
        let isUsernameNotNull = usernameOutlet.text ?? ""
        isUsernameValid = isUsernameNotNull.count > 4
        if isUsernameValid {
            checkListUsername.isHidden = false
        } else {
            checkListUsername.isHidden = true
        }
        
        isEmailValid = emailOutlet.validEmail(emailOutlet.text ?? "")
        if isEmailValid {
            checkListEmail.isHidden = false
        } else {
            checkListEmail.isHidden = true
        }
        
        isPasswordValid = passwordOutlet.validPassword(passwordOutlet.text ?? "")
        if isPasswordValid {
            cekStrongPass.isHidden = false
        } else {
            cekStrongPass.isHidden = true
        }
        
        isPasswordValid = confirmPassOutlet.validPassword(confirmPassOutlet.text ?? "" )
        if isConfirmPassValid {
            cekStrongConfirmPass.isHidden = false
        } else {
            cekStrongConfirmPass.isHidden = true
        }
    }
    
    
    // MARK: - Func change the textField
    @objc private func textFieldDidChange() {
        ceklisValidasi()
        if usernameOutlet.hasText && emailOutlet.hasText && passwordOutlet.hasText && confirmPassOutlet.hasText{
            signUpOutlet.isEnabled = true
            signUpOutlet.backgroundColor = UIColor(named: "ColorBg")
            signUpOutlet.tintColor = UIColor(named: "ColorWhite")
        } else {
            signUpOutlet.isEnabled = false
            signUpOutlet.backgroundColor = UIColor(named: "ColorDarkValid")
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
    
    // MARK: - Func for add new user using API
    func signUpUserWithAPI() {
        let username = usernameOutlet.text ?? ""
        let email = emailOutlet.text ?? ""
        let password = passwordOutlet.text ?? ""
        
        signUpViewModel.signUpUserAPI(username: username, email: email, password: password) { result in
            self.stopLoading()
            switch result {
            case .success(let json):
                // Panggil metode untuk berpindah ke view controller selanjutnya
                DispatchQueue.main.async {
                    ShowAlert.signUpApi(on: self, title: "Succesfully Created Account", message: "Please check your email to confrim the verification")
                    self.loginVcController()
                }
                print("Response JSON Sign Up: \(String(describing: json))")
            case .failure(let error):
                self.signUpViewModel.apiAlertSIgnUp = { status, description in
                    DispatchQueue.main.async {
                        ShowAlert.signUpApi(on: self, title: status, message: description)
                    }
                }
                print("JSON Sign Up Error: \(error)")
            }
        } 
    }
    
    //fungsi tabBar
    func loginVcController(){
        let loginCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        loginCtrl.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(loginCtrl, animated: true)
    }
    
    // MARK: - Sign Up Button
    @IBAction func signUpBtnAct(_ sender: Any) {
        startLoading()
        //signUp with API
        signUpUserWithAPI()
    }
    
    
    // MARK: - eye password button
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
    
    @IBAction func eyeConfrimPassBtn(_ sender: Any) {
        if iconClick {
            iconClick = true
            confirmPassOutlet.isSecureTextEntry = false
        } else {
            iconClick = false
            passwordOutlet.isSecureTextEntry = true
            confirmPassOutlet.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    
    
    // MARK: - Switch Button
    //fungsi switch button untuk menyimpan data di user default jadi kalau misalnya klik button on maka data akan di simpan di user default
    @IBAction func saveUserData(_ sender: Any) {
//        if (sender as AnyObject).isOn {
//            let username = usernameOutlet.text ?? ""
//            let email = emailOutlet.text ?? ""
//            let password = passwordOutlet.text ?? ""
//
////            let userDetail = allUser(username: username, email: email, password: password)
//
//            signUpViewModel.isSaveUserDataOn = (sender as AnyObject).isOn
//            signUpViewModel.saveUserDefault(userDetail)
//            UserDefaults.standard.set(true, forKey: signUpTrue)
//        } else {
//            // Remove data from UserDefaults
//            UserDefaults.standard.removeObject(forKey: savedUser)
//            print("User data removed from UserDefaults.")
//        }
    }
}

