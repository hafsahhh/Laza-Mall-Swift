//
//  ProfileVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 14/08/23.
//

import UIKit

class ProfileVC: UIViewController {
    
    
    @IBOutlet weak var userImageView: UIImageView!
//    {
//        didSet{
//            userImageView.layer.cornerRadius = userImageView.frame.width / 2
//            userImageView.layer.masksToBounds = true
//            userImageView.contentMode = .scaleToFill
//        }
//    }
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.layer.masksToBounds = true
        userImageView.contentMode = .scaleToFill
        
    }
    
    @IBAction func editImageUserBtn(_ sender: UIButton) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
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
