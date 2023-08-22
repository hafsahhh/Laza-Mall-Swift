//
//  editProfileVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 21/08/23.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func updateProfileUser(){
        
        let fullname = editNameView.text ?? ""
        let username = editUsernameView.text ?? ""
        let email = editEmailView.text ?? ""
//        guard let token = ApiService().token else {
//            print("belum ada token")
//            return }
        print(fullname, username, email)
        
        editProfileViewModel.updateProfileUser(username: username, fullname: fullname, email: email) { result in
            switch result {
            case .success(let json):
                // Panggil metode untuk berpindah ke view controller selanjutnya
                self.editProfileViewModel.apiAlertProfile = { status, data in
                    DispatchQueue.main.async {
                        ShowAlert.signUpApi(on: self, title: status, message: data)
                    }
                }
                print("Response JSON Sign Up: \(String(describing: json))")
            case .failure(let error):
                self.editProfileViewModel.apiAlertProfile = { status, description in
                    DispatchQueue.main.async {
                        ShowAlert.signUpApi(on: self, title: status, message: description)
                    }
                }
                print("JSON Edit Profile Error: \(error)")
            }
        }
    }
    
    
    @IBAction func saveProfileBtn(_ sender: UIButton) {
        updateProfileUser()
    }
}
