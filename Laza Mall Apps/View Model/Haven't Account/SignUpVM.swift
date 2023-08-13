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
    
    // MARK: - Func signUpUserAPI
    func signUpUserAPI(username: String,
                           email: String,
                           password: String,
                           completion: @escaping (Result<Any, Error>) -> Void)//closure atau blok kode yang dapat dilewatkan ke fungsi sebagai parameter
    {
            let urlString = "https://fakestoreapi.com/users"
            guard let url = URL(string: urlString) else { return }
            
            let userDetail = allUser(
                username: username,
                email: email,
                password: password
            )
            
            do {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(userDetail)
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            completion(.success(json))
                        } catch {
                            completion(.failure(error))
                        }
                    }
                }.resume()
            } catch {
                completion(.failure(error))
            }
        }
    
    
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
