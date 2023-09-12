//
//  editProfileVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 21/08/23.
//

import UIKit

protocol EditProfileDelegate: AnyObject {
    func onProfileUpdated(updatedProfile: EditProfile)
}

class editProfileVC: UIViewController {
    
    @IBOutlet weak var editImageView: UIImageView!
    {
        didSet{
            guard let imageEdit = profileModel?.image_url else {return}
            editImageView.layer.cornerRadius = editImageView.frame.width / 2
            editImageView.layer.masksToBounds = true
            editImageView.contentMode = .scaleToFill
            let imgURl = URL(string: "\(imageEdit )" )
            self.editImageView.sd_setImage(with: imgURl)
        }
    }
    @IBOutlet weak var imageEditBtn: UIButton!
    
    @IBOutlet weak var editNameTf: UITextField! {
        didSet{
            guard let name = profileModel?.fullName else {return}
            editNameTf.text = name
        }
    }
    @IBOutlet weak var editUsernameTf: UITextField! {
        didSet{
            guard let username = profileModel?.username else {return}
            editUsernameTf.text = username
        }
    }
    @IBOutlet weak var editEmailTf: UITextField! {
        didSet{
            guard let email = profileModel?.email else {return}
            editEmailTf.text = email
            editEmailTf.isEnabled = false
        }
    }
    @IBOutlet weak var saveProfileBtnView: UIButton!
    
    
    let editProfileViewModel = ProfileViewModel()
    var media: Media?
    weak var delegate: EditProfileDelegate?
    private let imagePicker = UIImagePickerController()
    var profileModel: DataUseProfile?
    var image: String = ""
    
    // MARK: - Button back using programmaticly
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
        
        //back button
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem  = backBarBtn
        
        setupView()
    }
    
    
    private func setupView() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        editImageView.layer.cornerRadius = editImageView.frame.height / 2
        editImageView.clipsToBounds = true
        
    }
    
    // MARK: - Fungsi untuk memperbarui profil pengguna
    func updateProfileUser(){
        let fullname = editNameTf.text ?? ""
        let username = editUsernameTf.text ?? ""
        let email = editEmailTf.text ?? ""
        // Menggunakan media (gambar) yang telah dipilih jika ada
        if let image = editImageView.image {
            media = Media(withImage: image, forKey: "image")
        }
        
        if username != "" && fullname != "" && email != "" {
            editProfileViewModel.updateProfile(fullName: fullname, username: username, email: email, media: media) { update in
                // Membuat objek DataUserProfile baru dengan data yang diperbarui
                let newProfile = DataUseProfile(
                    id: update.data.id,
                    fullName: update.data.fullName,
                    username: update.data.username,
                    email: update.data.email,
                    image_url: update.data.imageUrl,
                    isVerified: update.data.isVerified,
                    createdAt: update.data.createdAt,
                    updatedAt: update.data.updatedAt)
                
                // Menyimpan data profil yang diperbarui ke Keychain
                KeychainManager.shared.addProfileToKeychain(profile: newProfile, service: "UserProfileCoreData")
                DispatchQueue.main.async {
                    ShowAlert.performAlertApi(on: self, title: "Profile Notification", message: "Successfully Update Your Profile ")
                    self.navigationController?.popViewController(animated: true)
                }
                
                // Menampilkan pesan kesalahan jika terjadi kesalahan saat memperbarui profil
            } onError: { error in
                ShowAlert.performAlertApi(on: self, title: "Warning!", message: "Error")
            }
        }
        else {
            // Menampilkan pesan kesalahan jika ada kolom yang belum diis
            DispatchQueue.main.async {
                ShowAlert.performAlertApi(on: self, title: "Warning!", message: "Please filled all the form")
            }
        }
    }
    
    @IBAction func editPhotoBtn(_ sender: UIButton) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func saveProfileBtn(_ sender: UIButton) {
        updateProfileUser()
    }
}


extension editProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let result = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.editImageView.contentMode = .scaleToFill
            self.editImageView.image = result
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Failed", message: "Image can't be loaded.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
