//
//  MenuVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 01/08/23.
//

import UIKit

class MenuVC: UIViewController {
    
    let userDefault = UserDefaults.standard
    let saveDataLogin = "saveDataLogin"
    let userLoginTrue = "loginTrue"
    let menuViewModel = LoginViewModel()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var logoutBtnOutlet: UIButton!
    @IBOutlet weak var backMenu: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserProfile()
    }
    
    @IBAction func menuCloseBtn(_ sender: UIButton) {
        
    }
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        updateUsername()
    //    }
    
    func fetchUserProfile() {
        menuViewModel.getUserProfile { result in
            switch result {
            case .success(let userProfile):
                // Panggil fungsi untuk menampilkan data profil pengguna di tampilan
                self.displayUserProfile(userProfile)
            case .failure(let error):
                // Tangani kesalahan dengan sesuai
                print("Error fetching user profile: \(error)")
            }
        }
    }
    
    func displayUserProfile(_ userProfile: DataUseProfile?) {
        if let userProfile = userProfile {
            DispatchQueue.main.async {
                // Mengisi IBOutlets dengan data profil pengguna
                self.usernameLabel.text = userProfile.username
                let imgURl = URL(string: "\(userProfile.image_url )")
                self.imageView.sd_setImage(with: imgURl)
            }
        } else {
            // Failed to get user profile
            print("Failed to get user profile")
        }
    }
    
    @IBAction func switchBtnMode(_ sender: UISwitch) {
        
        let appDelegate = UIApplication.shared.windows.first
        if sender.isOn {
            appDelegate?.overrideUserInterfaceStyle = .dark
            return
        }
        appDelegate?.overrideUserInterfaceStyle =  .light
        return
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        // Menghapus data dari KeyChain
        KeychainManager.shared.deleteAccessToken()
        KeychainManager.shared.deleteRefreshToken()
        UserDefaults.standard.removeObject(forKey: "auth_token")
        UserDefaults.standard.removeObject(forKey: "loginTrue")
//        UserDefaults.standard.removeObject(forKey: userLoginTrue)
        let signInBtnAct = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateAccountVC") as! CreateAccountVC
        signInBtnAct.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(signInBtnAct, animated: true)
    }
    
    @IBAction func wishlistBtn(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarVC") as! UITabBarController
        vc.selectedIndex = 1 // index tabBar
//        self.present(vc, animated:true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationItem.hidesBackButton = true
//        self.navigationController?.view.window?.windowScene?.keyWindow?.rootViewController = vc
    }
    
    @IBAction func cardsMenuBtn(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarVC") as! UITabBarController
        vc.selectedIndex = 3 // index tabBar
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationItem.hidesBackButton = true
//        self.present(vc, animated:true, completion: nil)
//        self.navigationController?.view.window?.windowScene?.keyWindow?.rootViewController = vc
    }
    

    @IBAction func passwordMenuBtn(_ sender: Any) {
        let passwordBtn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangePasswordVC")as! ChangePasswordVC
        self.navigationController?.pushViewController(passwordBtn, animated: true)
    }
    
}
