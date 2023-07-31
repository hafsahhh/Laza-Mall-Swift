//
//  LoginVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 25/07/23.
//

import UIKit

class LoginVC: UIViewController {

    
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var loginBtnOutlet: UIButton!
    @IBOutlet weak var saveUserLoginOutlet: UISwitch!
    
    let userDefault = UserDefaults.standard
    let saveDataLogin = "saveDataLogin"
    
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
    
    // Mengubah warna pada button
    @objc func textFieldDidChange() {
        if usernameOutlet.hasText && passwordOutlet.hasText {
            loginBtnOutlet.isEnabled = true
            loginBtnOutlet.backgroundColor = UIColor(named: "ColorBg")
        } else {
            loginBtnOutlet.isEnabled = false
            loginBtnOutlet.backgroundColor = UIColor(named: "ColorValid")
        }
    }

    
    // MARK: - Login Button
    @IBAction func loginBtnAct(_ sender: UIButton) {
        guard let username = usernameOutlet.text, let password = passwordOutlet.text else {
            return
        }
        // Panggil fungsi untuk melakukan login dan mendapatkan data user
        loginAndGetData(username: username, password: password)
    }
    
    // Panggil fungsi getData dari kelas UserAllApi
    func loginAndGetData(username: String, password: String) {

        UserAllApi().getData { userIndex in
            // Lakukan pengecekan apakah ada user dengan username dan password yang sesuai dalam data userIndex
            let matchingUser = userIndex.first { user in
                user.username == username && user.password == password
            }
            
            if let user = matchingUser {
                // Login berhasil, tampilkan pesan sukses atau navigasi ke halaman berikutnya
                print("Login berhasil, user: \(user)")
                DispatchQueue.main.async {
                    self.tabBarController()
                }
            } else {
                // Login gagal, tampilkan pesan error atau notifikasi bahwa username atau password salah
                print("Login gagal, username atau password salah.")
            }
        }
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
    
    func tabBarController(){
        let tabbarVC = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
        tabbarVC.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(tabbarVC, animated: true)
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
            let userDetail = allUser(name: Name(firstname: "", lastname: ""), username: usernameOutlet.text ?? "", email: "", phone: "", password: passwordOutlet.text ?? "")
            saveUserDefault(userDetail)
        } else {
            // If the switch is turned off, you can decide what to do here.
            // You might want to remove user data from UserDefaults as you do in the saveUserDefault function.
            UserDefaults.standard.removeObject(forKey: saveDataLogin)
            print("User data removed from UserDefaults.")
        }
    }
    
}
