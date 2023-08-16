//
//  ShowAlert.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 06/08/23.
//

import UIKit

class ShowAlert {
    private static func showAlert(on viewControl: UIViewController, title:String, message: String){
      DispatchQueue.main.async{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          viewControl.present(alert, animated: true)
      }
    }
    
    public static func signUpApi(on viewController:UIViewController, title titleAlert:String, message messageAlert:String){
        self.showAlert(on: viewController, title: titleAlert, message: messageAlert)
    }
    
    public static func failedSignUpApi(on viewController:UIViewController, title titleAlert:String, message messageAlert:String){
        self.showAlert(on: viewController, title: titleAlert, message: messageAlert)
    }
    
    public static func passwordDoestMatch(on viewController:UIViewController){
      self.showAlert(on: viewController, title: "Password Mismatch", message: "Password dosen't match")
    }
    
    public static func alertValidEmail(on viewController:UIViewController){
      self.showAlert(on: viewController, title: "Invalid Email", message: "Please try again. ex: sitiHafsah@gmail.com")
    }
    
    public static func alertValidPassword(on viewController:UIViewController){
      self.showAlert(on: viewController, title: "Invalid Password", message: "The password must be at least 8 characters long and contain at least one letter and one number. Ex: HelloWorld@123")
    }
    
    public static func alertChoosePayment(on viewController:UIViewController){
      self.showAlert(on: viewController, title: "Please Choose Payment", message: "Please choose payment methode between GoPay or Credit Card")
    }

}
