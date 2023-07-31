//
//  SignUpVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 25/07/23.
//

import UIKit

class SignUpVC: UIViewController {
    
    
    @IBOutlet weak var firstnameOutlet: UITextField!
    @IBOutlet weak var lastnameOutlet: UITextField!
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var phoneOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var signUpOutlet: UIButton!
    @IBOutlet weak var saveUserData: UISwitch!
    
    let userDefault = UserDefaults.standard
    //key untuk userdefault
    let SavedUser = "SavedUser"
    
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
        
        signUpOutlet.isEnabled = false
        passwordOutlet.isSecureTextEntry = true
        
        emailOutlet.addTarget(self, action:  #selector(cekValidasi),  for:.editingChanged )
        passwordOutlet.addTarget(self, action:  #selector(cekValidasi),  for:.editingChanged )
        
        loadUserData()
    }
    
    
    //fungsi untuk menambahkan data
    func signUpUser() {
        let urlString = "https://fakestoreapi.com/users"
        guard let url = URL(string: urlString) else { return }
        
        // Prepare the data to be sent in JSON format
        let userDetail = allUser (
            name: Name(firstname: firstnameOutlet.text ?? "", lastname: lastnameOutlet.text ?? ""),
            username: usernameOutlet.text ?? "",
            email: emailOutlet.text ?? "",
            phone: phoneOutlet.text ?? "",
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
                    // Handle error here (e.g., show an alert)
                    return
                }
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print("Response JSON: \(json)")
                        
                        //                        self.saveUserDefault(userDetail)
                        //                        self.checkUserDefaultsData()
                        
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
                defaults.set(encoded, forKey: SavedUser)
                print("User data saved to UserDefaults.")
            } catch {
                print("Failed to encode user data: \(error.localizedDescription)")
            }
        } else {
            UserDefaults.standard.removeObject(forKey: SavedUser)
            print("User data removed from UserDefaults.")
        }
        
        //untuk mengecek file userdefault
        let path: [AnyObject] = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true) as [AnyObject]
        let folder: String = path[0] as! String
        NSLog("Your NSUserDefaults are stored in this folder: %@/Preferences", folder)
    }
    
    //Fungsi untuk menampilkan user default yang ada di textfield
    func loadUserData() {
        if let savedData = UserDefaults.standard.data(forKey: SavedUser) {
            let decoder = JSONDecoder()
            if let userDetail = try? decoder.decode(allUser.self, from: savedData) {
                firstnameOutlet.text = userDetail.name.firstname
                lastnameOutlet.text = userDetail.name.lastname
                usernameOutlet.text = userDetail.username
                emailOutlet.text = userDetail.email
                phoneOutlet.text = userDetail.phone
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
        signUpUser()
    }
    
    
    // MARK: - Switch Button
    //fungsi switch button untuk menyimpan data di user default jadi kalau misalnya klik button on maka data akan di simpan di user default
    @IBAction func saveUserData(_ sender: Any) {
        if (sender as AnyObject).isOn {
            // Call the function here passing the user details to be saved
            let userDetail = allUser(
                name: Name(firstname: firstnameOutlet.text ?? "", lastname: lastnameOutlet.text ?? ""),
                username: usernameOutlet.text ?? "",
                email: emailOutlet.text ?? "",
                phone: phoneOutlet.text ?? "",
                password: passwordOutlet.text ?? ""
            )
            saveUserDefault(userDetail)
        } else {

            //remove data dari userdefault
            UserDefaults.standard.removeObject(forKey: SavedUser)
            print("User data removed from UserDefaults.")
        }
    }
    
    
    //membuat fungsi untuk cekvalidasi email dan password
    @objc private func cekValidasi(){
        let isEmailValid =
        //validasi email [validEmail] di folder extensions
        emailOutlet.validEmail(emailOutlet.text ?? "")
        let isPassValid =
        //validasi email [validPassword] di folder extensions
        passwordOutlet.validPassword(passwordOutlet.text ?? "")
        
        //jika email dan password valid maka button akan berwarna biru
        if isEmailValid || isPassValid{
            signUpOutlet.isEnabled = true
            signUpOutlet.backgroundColor = UIColor(named: "ColorBg" )
        } else {
            signUpOutlet.isEnabled = false
            signUpOutlet.backgroundColor = UIColor(named: "ColorValid" )
        }
        
    }
    
    //Mengubah warna pada button
    @objc func textFieldDidChange() {
        if emailOutlet.text == "" || passwordOutlet.hasText{
            signUpOutlet.isEnabled = false
            signUpOutlet.backgroundColor = UIColor(named: "ColorValid" )
        }else{
            signUpOutlet.isEnabled = true
            signUpOutlet.backgroundColor = UIColor(named: "ColorBg" )
        }
    }
    
    
}
