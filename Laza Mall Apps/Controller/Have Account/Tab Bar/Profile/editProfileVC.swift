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
//            editImageView.image = image
        }
    }
    @IBOutlet weak var imageEditBtn: UIButton!
    @IBOutlet weak var editNameView: UITextField! {
        didSet{
            editNameView.text = name
        }
    }
    @IBOutlet weak var editUsernameView: UITextField! {
        didSet{
            editUsernameView.text = userName
        }
    }
    @IBOutlet weak var editEmailView: UITextField! {
        didSet{
            editEmailView.text = email
        }
    }
    @IBOutlet weak var saveProfileBtnView: UIButton!
    
    
    let editProfileViewModel = ProfileViewModel()
    var media: Media?
    weak var delegate: EditProfileDelegate?
    private let imagePicker = UIImagePickerController()
    var email: String = ""
    var name: String = ""
    var userName: String = ""
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
    
    func updateProfileUser(){
        let fullname = editNameView.text ?? ""
        let username = editUsernameView.text ?? ""
        let email = editEmailView.text ?? ""
        if let image = editImageView.image {
            media = Media(withImage: image, forKey: "image")
        }
        
        if username != "" && fullname != "" && email != "" {
            editProfileViewModel.updateProfile(fullName: fullname, username: username, email: email, media: media) { update in
                DispatchQueue.main.async {
                    ShowAlert.performAlertApi(on: self, title: "Success", message: "Successfully ")
                    print("Alert profile")
                    self.navigationController?.popViewController(animated: true)
                }
                
            } onError: { error in
                ShowAlert.performAlertApi(on: self, title: "Warning!", message: "Error")
            }
        }
        else {
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
            //            titleButton.isEnabled = true
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Failed", message: "Image can't be loaded.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
