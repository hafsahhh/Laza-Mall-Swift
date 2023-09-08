//
//  MenuVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 01/08/23.
//

import UIKit

protocol protocolTabBarDelegate: AnyObject {
  func protocolGoToWishlist()
  func protocolGoToCart()
  func protocolGoToProfile()
  func protocolGoToChangePassword()
}

class MenuVC: UIViewController {
    
    let userDefault = UserDefaults.standard
    let saveDataLogin = "saveDataLogin"
    let userLoginTrue = "loginTrue"
    let menuViewModel = LoginViewModel()
    var modelProfile : DataUseProfile?
    weak var delegate: protocolTabBarDelegate?
    
    @IBOutlet weak var imageUiviewOutlet: UIImageView!
    {
        didSet{
            imageUiviewOutlet.layer.cornerRadius = imageUiviewOutlet.frame.width / 2
            imageUiviewOutlet.layer.masksToBounds = true
            imageUiviewOutlet.contentMode = .scaleToFill
        }
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var logoutBtnOutlet: UIButton!
    @IBOutlet weak var backMenu: UIButton!
    @IBOutlet weak var switchModeOutlet: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayUserProfile()
        darkModeInSwitch()
    }
    
    @IBAction func menuCloseBtn(_ sender: UIButton) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        ApiRefreshToken().refreshTokenIfNeeded { [weak self] in
            self?.displayUserProfile()
        } onError: { errorMessage in
            print(errorMessage)
        }
        
    }
    

    
    func displayUserProfile() {
        DispatchQueue.main.async {
            guard let dataUser = KeychainManager.shared.getProfileFromKeychain(service: "UserProfileCoreData") else {return}
            self.usernameLabel.text = dataUser.username
            let imgURl = URL(string: dataUser.image_url ?? "")
            self.imageUiviewOutlet.sd_setImage(with: imgURl)
        }
    }
    
    
    
    @IBAction func switchBtnMode(_ sender: UISwitch) {
        if sender.isOn {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let appDelegate = windowScene.windows.first
                appDelegate?.overrideUserInterfaceStyle = .dark
            }
            UserDefaults.standard.setValue(true, forKey: "darkmode")
        } else {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let appDelegate = windowScene.windows.first
                appDelegate?.overrideUserInterfaceStyle = .light
            }
            UserDefaults.standard.setValue(false, forKey: "darkmode")
        }
        
//        let appDelegate = UIApplication.shared.windows.first
//        if sender.isOn {
//            appDelegate?.overrideUserInterfaceStyle = .dark
//            return
//        }
//        appDelegate?.overrideUserInterfaceStyle =  .light
//        return
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        // Menghapus data dari KeyChain
        KeychainManager.shared.deleteAccessToken()
        KeychainManager.shared.deleteRefreshToken()
        UserDefaults.standard.removeObject(forKey: "auth_token")
        UserDefaults.standard.removeObject(forKey: "loginTrue")
        UserDefaults.standard.removeObject(forKey: "UserProfileDefault")
        let signInBtnAct = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        signInBtnAct.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(signInBtnAct, animated: true)
    }
    
    @IBAction func wishlistBtn(_ sender: Any) {
        self.dismiss(animated: true)
        delegate?.protocolGoToWishlist()
    }
    
    @IBAction func profileMenuBtn(_ sender: Any) {
        self.dismiss(animated: true)
        delegate?.protocolGoToProfile()

    }
    

    @IBAction func passwordMenuBtn(_ sender: Any) {
        self.dismiss(animated: true)
        delegate?.protocolGoToChangePassword()
    }
    
    
    @IBAction func cartMenuBtn(_ sender: Any) {
        self.dismiss(animated: true)
        delegate?.protocolGoToCart()
    }
    
    func darkModeInSwitch() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "darkmode")
        if isDarkMode {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let appDelegate = windowScene.windows.first
                appDelegate?.overrideUserInterfaceStyle = .dark
            }
            switchModeOutlet.isOn = true
        } else {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let appDelegate = windowScene.windows.first
                appDelegate?.overrideUserInterfaceStyle = .light
            }
            switchModeOutlet.isOn = false
        }
    }
}
