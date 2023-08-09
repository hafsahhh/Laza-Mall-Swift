//
//  Extension.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 26/07/23.
//

import Foundation
import UIKit

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    func addShadow(color: UIColor, width: CGFloat, text: UITextField) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: text.frame.height + 10 , width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
        }
}


extension UIImage {
    // This method creates an image of a view
    convenience init?(view: UIView) {
        
        // Based on https://stackoverflow.com/a/41288197/1118398
        
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        let image = renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }
        
        if let cgImage = image.cgImage {
            self.init(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
        } else {
            return nil
        }
    }
}

extension String{
    var imageFromBase64: UIImage? {
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}

extension UICollectionViewCell {
    func shadowDecorate() {
        let radius: CGFloat = 10
        contentView.layer.cornerRadius = radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.masksToBounds = true
        layer.cornerRadius = radius
    }
}

extension UITextField {
    
    //nerima string output boolean
    func validEmail(_ value:String) -> Bool {
        let emailValid = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailValid)
        if emailPred.evaluate(with: value){
            return true
        }
        return false
    }
    
//    Minimum 8 characters at least 1 Alphabet, 1 Number and 1 Special Character:
    func validPassword(_ value:String) -> Bool {
        let regularExpression = "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        if predicate.evaluate(with: value){
          return true
        }
        return false
    }
}

extension UITextView {
//     Berfungsi sebagai "keys" untuk menyimpan dan mengambil nilai-nilai tambahan (associated objects) pada UITextView.
    public struct AssociatedKeys {
        static var placeholderLabel = "placeholderLabel"
    }
    
    // Computed property untuk menambahkan placeholder pada UITextView
    var placeholder: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.placeholderLabel) as? String
        }
        set {
            if let newValue = newValue {
                if let placeholderLabel = objc_getAssociatedObject(self, &AssociatedKeys.placeholderLabel) as? UILabel {
                    placeholderLabel.text = newValue
                } else {
                    addPlaceholderLabel(newValue)
                }
            } else {
                removePlaceholderLabel()
            }
        }
    }
    
    // Fungsi untuk menambahkan UILabel sebagai placeholder
    private func addPlaceholderLabel(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholderText
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.font = font
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 8) // Atur posisi placeholder sesuai keinginan
        placeholderLabel.tag = 100 // Tag digunakan untuk kemudahan identifikasi jika perlu dihapus nanti
        addSubview(placeholderLabel)
        bringSubviewToFront(placeholderLabel)
        objc_setAssociatedObject(self, &AssociatedKeys.placeholderLabel, placeholderLabel, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    // Fungsi untuk menghapus placeholder saat UITextView tidak kosong
    private func removePlaceholderLabel() {
        if let placeholderLabel = objc_getAssociatedObject(self, &AssociatedKeys.placeholderLabel) as? UILabel {
            placeholderLabel.removeFromSuperview()
            NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
        }
    }
    
    // Fungsi yang dipanggil saat isi UITextView berubah
    @objc private func textChanged() {
        if let placeholderLabel = objc_getAssociatedObject(self, &AssociatedKeys.placeholderLabel) as? UILabel {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
}

extension UIButton {
    //MARK:- Animate check mark
    func checkboxAnimation(closure: @escaping () -> Void){
        guard let image = self.imageView else {return}
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            image.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.isSelected = !self.isSelected
                //to-do
                closure()
                image.transform = .identity
            }, completion: nil)
        }
        
    }
}
