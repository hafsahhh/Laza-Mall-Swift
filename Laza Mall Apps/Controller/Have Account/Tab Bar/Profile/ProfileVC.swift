//
//  ProfileVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 14/08/23.
//

import UIKit

class ProfileVC: UIViewController {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    {
        didSet{
            userImageView.layer.cornerRadius = userImageView.frame.width / 2
            userImageView.layer.masksToBounds = true
            userImageView.contentMode = .scaleToFill
        }
    }
    @IBOutlet weak var fullnameProfileView: UILabel!
    @IBOutlet weak var usernameProfileView: UILabel!
    @IBOutlet weak var emailProfileView: UILabel!
    
    
    let imagePicker = UIImagePickerController()
    let profileViewModel = LoginViewModel()
    var linkImage: String = ""
    var modelProfile : DataUseProfile?
    
    //Profile
    private func setupTabBarText() {
        let label4 = UILabel()
        label4.numberOfLines = 1
        label4.textAlignment = .center
        label4.text = "Profile"
        label4.font = UIFont(name: "inter-Medium", size: 11)
        label4.sizeToFit()
        
        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "colorBg")
        tabBarItem.selectedImage = UIImage(view: label4)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide back button
        navigationItem.hidesBackButton = true
        
        //func tab Bar action
        setupTabBarText()
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.layer.masksToBounds = true
        userImageView.contentMode = .scaleAspectFill
        
        displayUserProfileByUserdefault()
        
//        fetchUserProfile()
//        loginViewModel.performLogin(username: "your_username", password: "your_password")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        ApiRefreshToken().refreshTokenIfNeeded { [weak self] in
            self?.displayUserProfileByUserdefault()
        } onError: { errorMessage in
            print(errorMessage)
        }
    }
    
    //func untuk menampilkan data user menggunakan api
    func fetchUserProfile() {
        profileViewModel.getUserProfile { result in
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
                self.fullnameProfileView.text = userProfile.fullName
                self.usernameProfileView.text = userProfile.username
                self.emailProfileView.text = userProfile.email
                self.linkImage = String(userProfile.image_url ?? "")
                let imgURl = URL(string: userProfile.image_url ?? "")
                self.userImageView.sd_setImage(with: imgURl)
            }
        } else {
            // Failed to get user profile
            print("Failed to get user profile")
        }
    }
    
    func displayUserProfileByUserdefault() {
        DispatchQueue.main.async {
            if let data = UserDefaults.standard.object(forKey: "UserProfileDefault") as? Data,
               let profile = try? JSONDecoder().decode(profileUser.self, from: data) {
                self.modelProfile = profile.data
            }
            
            self.fullnameProfileView.text = self.modelProfile?.fullName
            self.usernameProfileView.text = self.modelProfile?.username
            self.emailProfileView.text = self.modelProfile?.email
            self.linkImage = String(self.modelProfile?.image_url ?? "")
            let imgURl = URL(string: self.modelProfile?.image_url ?? "")
            self.userImageView.sd_setImage(with: imgURl)
        }
    }
    
    @IBAction func editImageUserBtn(_ sender: UIButton) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func editProfileBtn(_ sender: UIButton) {
        guard let emailProfile = emailProfileView.text else {return}
        guard let nameProfile = fullnameProfileView.text else {return}
        guard let usernameProfile = usernameProfileView.text else {return}
        let editProfileCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editProfileVC") as! editProfileVC
        editProfileCtrl.email = emailProfile
        editProfileCtrl.name = nameProfile
        editProfileCtrl.userName = usernameProfile
//        editProfileCtrl.image = linkImage
        
        self.navigationController?.pushViewController(editProfileCtrl, animated: true)
    }
    
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImageView.contentMode = .scaleAspectFit
            userImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
