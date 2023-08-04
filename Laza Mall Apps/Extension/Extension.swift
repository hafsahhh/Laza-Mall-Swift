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
        let passwordValid =
        "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
//        "^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordValid)
        if passwordPred.evaluate(with: value){
            return true
        }
        return false
    }
}

