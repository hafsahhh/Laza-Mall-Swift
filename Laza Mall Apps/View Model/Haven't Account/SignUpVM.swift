//
//  SignUpVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 13/08/23.
//

import Foundation

class SignUpViewModel {
    
    let userDefault = UserDefaults.standard
    //key untuk userdefault
    let savedUser = "savedUser"
    let signUpUserDefault = "signUpUserDefault"
    
    // Properti yang merepresentasikan status UISwitch
    var isSaveUserDataOn: Bool = false // Default value
    //untuk menampilkan alert
    var apiAlertSIgnUp: ((String, String) -> Void)?
    
    // MARK: - Fungsi untuk mendaftarkan pengguna melalui API
    func signUpUserAPI(username: String, email: String, password: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        
        // Membuat URL untuk endpoint pendaftaran
        guard let url = URL(string: Endpoints.Gets.register.url) else {
            completion(.failure(ErrorInfo.Error))
            return
        }
        
        // Membuat permintaan URLRequest dengan metode HTTP POST dan data yang dibutuhkan
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = ApiService.getHttpBodyRaw(param: [
            "full_name": username,
            "username": username,
            "email": email,
            "password": password
        ])
        
        // Melakukan permintaan HTTP untuk mendaftarkan pengguna
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if statusCode != 201 {
                    // Error: Menangani respons dengan status code yang tidak berhasil
                    print("Kode Status Respons: \(statusCode)")
                    if let data = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let description = jsonResponse["description"] as? String,
                       let status = jsonResponse["status"] as? String {
                        
                        DispatchQueue.main.async {
                            // Memanggil penanganan respons API
                            self.apiAlertSIgnUp?(status, description)
                        }
                    }
                    completion(.failure(ErrorInfo.Error))
                } else {
                    // Sukses: Menangani respons berhasil
                    print("Berhasil mendaftar")
                    completion(.success(data))
                }
            }
        }.resume()
    }
    
    
//    // MARK: - Func Userdefault
//    //fungsi userdefault untuk menyimpan textfield yang sudah terisi
//    func saveUserDefault(_ userDetail: allUser){
//        // Dengan mengansumsikan memiliki variabel 'saveUserDataSwitch' yang mewakili tombol sakelar
//        if isSaveUserDataOn {
//            let defaults = UserDefaults.standard
//            let encodedData: [String: Any] = [
//                "username": userDetail.username,
//                "email": userDetail.email,
//                "password": userDetail.password
//            ]
//            
//            defaults.set(encodedData, forKey: savedUser)
//            UserDefaults.standard.set(true, forKey: signUpUserDefault)
//            print("User data saved to UserDefaults.")
//        } else {
//            UserDefaults.standard.removeObject(forKey: savedUser)
//            print("User data removed from UserDefaults.")
//        }
//        
//        //untuk mengecek file userdefault
//        //        let path: [AnyObject] = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true) as [AnyObject]
//        //        let folder: String = path[0] as! String
//        //        NSLog("Your NSUserDefaults are stored in this folder: %@/Preferences", folder)
//    }
}


