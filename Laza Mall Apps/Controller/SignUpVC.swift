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
    @IBOutlet weak var eyePassOutlet: UIButton!
    
    
    let userDefault = UserDefaults.standard
    //key untuk userdefault
    let savedUser = "savedUser"
    let signUpUserDefault = "signUpUserDefault"
    var iconClick = true
    
    
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
        
        // Lakukan validasi awal
        validateTextFields()
        
        loadUserData()
    }
    
    private func signUp() {
        guard let username = usernameOutlet.text,
              let email = emailOutlet.text,
              let password = passwordOutlet.text,
              let confirmPassword = confirmPassOutlet.text else {
            return
        }
        
        // Check if password and confirm password match
        guard confirmPassword == confirmPassOutlet.text else {
            showAlert(title: "Password Mismatch", message: "Password dosen't match")
            return
        }
        
        // Validasi password regex
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let isPasswordValid = passwordPredicate.evaluate(with: password)
        
        // Validasi email regex
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isEmailValid = emailPredicate.evaluate(with: email)
    
        
        // cek validasi emial dan password
        if !isEmailValid {
            showAlert(title: "Invalid Email", message: "Please try again. ex: sitiHafsah@gmail.com")
        } else if !isPasswordValid {
            showAlert(title: "Invalid Password", message: "The password must be at least 8 characters long and contain at least one letter and one number. Ex: HelloWorld123")
        } else {
            self.tabBarController()
        }
        
        
    }
    
    
    
    
    //fungsi untuk menambahkan data
    func signUpUser() {
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
        signUp()
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
    
    
    @objc private func textFieldDidChange() {
         validateTextFields()
     }
     
     private func validateTextFields() {
         // Jika salah satu text field kosong, nonaktifkan tombol sign up dan beri warna abu-abu
         guard let username = usernameOutlet.text, !username.isEmpty,
               let email = emailOutlet.text, !email.isEmpty,
               let confirmPassword = confirmPassOutlet.text, !confirmPassword.isEmpty,
               let password = passwordOutlet.text, !password.isEmpty else {
             signUpOutlet.isEnabled = false
             signUpOutlet.alpha = 0.5
             signUpOutlet.backgroundColor = UIColor.gray
             return
         }
         signUpOutlet.isEnabled = true
         signUpOutlet.alpha = 1.0
         signUpOutlet.backgroundColor = UIColor(red: 151/255, green: 117/255, blue: 250/255, alpha: 1.0)
     }
     
     private func showAlert(title: String, message: String) {
         let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
         alertController.addAction(okAction)
         present(alertController, animated: true, completion: nil)
     }
}
