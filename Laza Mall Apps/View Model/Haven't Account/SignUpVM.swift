//
//  SignUpVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 13/08/23.
//

import Foundation
import UIKit

class SignUpViewModel {
    
    let userDefault = UserDefaults.standard
    //key untuk userdefault
    let savedUser = "savedUser"
    let signUpUserDefault = "signUpUserDefault"
    
    // Properti yang merepresentasikan status UISwitch
    var isSaveUserDataOn: Bool = false // Default value
    

    // MARK: - Func Userdefault
    //fungsi userdefault untuk menyimpan textfield yang sudah terisi
    func saveUserDefault(_ userDetail: allUser){
        // Dengan mengansumsikan memiliki variabel 'saveUserDataSwitch' yang mewakili tombol sakelar
        if isSaveUserDataOn {
            let defaults = UserDefaults.standard
            let encodedData: [String: Any] = [
                "username": userDetail.username,
                "email": userDetail.email,
                "password": userDetail.password
            ]
            
            defaults.set(encodedData, forKey: savedUser)
            UserDefaults.standard.set(true, forKey: signUpUserDefault)
            print("User data saved to UserDefaults.")
        } else {
            UserDefaults.standard.removeObject(forKey: savedUser)
            print("User data removed from UserDefaults.")
        }
        
        //untuk mengecek file userdefault
        //        let path: [AnyObject] = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true) as [AnyObject]
        //        let folder: String = path[0] as! String
        //        NSLog("Your NSUserDefaults are stored in this folder: %@/Preferences", folder)
    }
}
