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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func menuCloseBtn(_ sender: UIButton) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        ApiRefreshToken().refreshTokenIfNeeded { [weak self] in
            self?.fetchUserProfile()
        } onError: { errorMessage in
            print(errorMessage)
        }
        
    }
    
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
                let imgURl = URL(string: userProfile.image_url ?? "")
                self.imageUiviewOutlet.sd_setImage(with: imgURl)
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
        let signInBtnAct = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateAccountVC") as! CreateAccountVC
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
    
}
