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
    
    
    let userDefault = UserDefaults.standard
    //key untuk userdefault
    let savedUser = "savedUser"
    let signUpUserDefault = "signUpUserDefault"
    var iconClick = true
    var isEmailValid = false
    var isUsernameValid = false
    var isPasswordValid = false
    var isConfirmPassValid = false
    
    
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
        
        
        // Tambahkan target untuk text field untuk melakukan validasi saat text berubah
        usernameOutlet.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailOutlet.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordOutlet.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        confirmPassOutlet.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        //Fungsi untuk menampilkan user default yang ada di textfield
        loadUserData()
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
        else {
            self.tabBarController()
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
        } else {
            signUpOutlet.isEnabled = false
            signUpOutlet.backgroundColor = UIColor(named: "ColorValid")
        }
    }
    
    
    // MARK: - Func for add new user using API
    func signUpUserWithAPI() {
        let urlString = "https://fakestoreapi.com/users"
        guard let url = URL(string: urlString) else { return }
        
        // Prepare the data to be sent in JSON format
        let userDetail = allUser (
            username: usernameOutlet.text ?? "",
            email: emailOutlet.text ?? "",
            password: passwordOutlet.text ?? ""
        )
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(userDetail)
            //            let jsonData = try JSONSerialization.data(withJSONObject: userData, options: [])
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            // Send the request
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print("Response JSON: \(json)")
                        DispatchQueue.main.async {
                            self.tabBarController()
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                        // Handle error in parsing JSON response
                    }
                }
            }.resume()
        } catch {
            print("Error creating JSON data: \(error)")
            // Handle error in creating JSON data
        }
    }
    
    
    // MARK: - Func Userdefault
    //fungsi userdefault untuk menyimpan textfield yang sudah terisi
    func saveUserDefault(_ userDetail: allUser){
        // Dengan mengansumsikan memiliki variabel 'saveUserDataSwitch' yang mewakili tombol sakelar
        if saveUserData.isOn {
            let defaults = UserDefaults.standard
            let encoder = JSONEncoder()
            do {
                let encoded = try encoder.encode(userDetail)
                defaults.set(encoded, forKey: savedUser)
                UserDefaults.standard.set(true, forKey: signUpUserDefault )
                print("User data saved to UserDefaults.")
            } catch {
                print("Failed to encode user data: \(error.localizedDescription)")
            }
        } else {
            UserDefaults.standard.removeObject(forKey: savedUser)
            print("User data removed from UserDefaults.")
        }
        
        //untuk mengecek file userdefault
        //        let path: [AnyObject] = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true) as [AnyObject]
        //        let folder: String = path[0] as! String
        //        NSLog("Your NSUserDefaults are stored in this folder: %@/Preferences", folder)
    }
    
    //Fungsi untuk menampilkan user default yang ada di textfield
    func loadUserData() {
        if let savedData = UserDefaults.standard.data(forKey: savedUser) {
            let decoder = JSONDecoder()
            if let userDetail = try? decoder.decode(allUser.self, from: savedData) {
                usernameOutlet.text = userDetail.username
                emailOutlet.text = userDetail.email
                passwordOutlet.text = userDetail.password
            }
        }
    }
    
    //fungsi tabBar
    func tabBarController(){
        let tabbarVC = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
        tabbarVC.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(tabbarVC, animated: true)
    }
    
    // MARK: - Sign Up Button
    @IBAction func signUpBtnAct(_ sender: Any) {
        signUpValidate()
//        signUpUser()
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
        if (sender as AnyObject).isOn {
            // Call the function here passing the user details to be saved
            let userDetail = allUser(
                username: usernameOutlet.text ?? "",
                email: emailOutlet.text ?? "",
                password: passwordOutlet.text ?? ""
            )
            saveUserDefault(userDetail)
        } else {
            
            //remove data dari userdefault
            UserDefaults.standard.removeObject(forKey: savedUser)
            print("User data removed from UserDefaults.")
        }
    }
}
