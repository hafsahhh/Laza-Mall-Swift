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
            editImageView.layer.cornerRadius = editImageView.frame.width / 2
            editImageView.layer.masksToBounds = true
            editImageView.contentMode = .scaleToFill
        }
    }
    @IBOutlet weak var imageEditBtn: UIButton!
    @IBOutlet weak var editNameView: UITextField!
    @IBOutlet weak var editUsernameView: UITextField!
    @IBOutlet weak var editEmailView: UITextField!
    @IBOutlet weak var saveProfileBtnView: UIButton!
    
    
    let editProfileViewModel = ProfileViewModel()
    var media: Media?
    weak var delegate: EditProfileDelegate?
    private let imagePicker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        editImageView.layer.cornerRadius = editImageView.frame.height / 2
        editImageView.clipsToBounds = true
        
    }
    
    func updateProfileUser(){
        
        let fullname = editNameView.text ?? ""
        let username = editUsernameView.text ?? ""
        let email = editEmailView.text ?? ""
        if let image = editImageView.image {
            media = Media(withImage: image, forKey: "image")
        }
//        guard let token = ApiService().token else {
//            print("belum ada token")
//            return }
        print(fullname, username, email)

        
        if username != "" && fullname != "" && email != "" {
            editProfileViewModel.updateProfile(fullName: fullname, username: username, email: email, media: media) { update in
                    print("move")
                    let updateVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                    self.navigationController?.pushViewController(updateVC, animated: true)
                
            } onError: { error in
                self.editProfileViewModel.apiAlertProfile = { status, description in
                    DispatchQueue.main.async {
                        ShowAlert.performAlertApi(on: self, title: status, message: description)
                    }
                }
            }

        } else {
            self.editProfileViewModel.apiAlertProfile = { status, description in
                DispatchQueue.main.async {
                    ShowAlert.performAlertApi(on: self, title: status, message: description)
                }
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
//            titleButton.isEnabled = true
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Failed", message: "Image can't be loaded.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
