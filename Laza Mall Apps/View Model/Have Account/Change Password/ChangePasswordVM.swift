//
//  ChangePasswordVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 03/09/23.
//

import Foundation
class ChangePasswordViewModel  {
    
    // Closure untuk menampilkan pesan alert
    var alertChangePassword: ((String) -> Void)?
    
    // Fungsi untuk mengganti password
    func getPassEmail(oldPassword: String, newPassword:String, confirmNewPassword:String,
                      completion: @escaping (Result<Data?, Error>) -> Void)//closure atau blok kode yang dapat dilewatkan ke fungsi sebagai parameter
   {

       // Membuat URL untuk endpoint forgot password
       guard let url = URL(string: Endpoints.Gets.changePassword.url) else {
           completion(.failure(ErrorInfo.Error))
           return
       }
       
       // Mendapatkan token akses dari Keychain
       guard let accesToken = KeychainManager.shared.getAccessToken() else { return }
       
       // Membuat permintaan HTTP
       var request = URLRequest(url: url)
       request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
       request.httpMethod = "PUT"
       request.httpBody = ApiService.getHttpBodyRaw(param: [
           "old_password": oldPassword,
           "new_password" : newPassword,
           "re_password" : confirmNewPassword
       ])
       
       // Melakukan permintaan HTTP dengan URLSession
       URLSession.shared.dataTask(with: request){
           (data, response, error) in
           if let error = error {
               print(error)
               return
           }
           let httpResponse = response as? HTTPURLResponse
           if let statusCode = httpResponse?.statusCode, statusCode != 200 {
               // Error
               print("Response Status Code: \(statusCode)")
               if let data = data,
                  let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let description = jsonResponse["description"] as? String{
                   
                   DispatchQueue.main.async {
                       self.alertChangePassword?(description)
                   }
               }
               completion(.failure(ErrorInfo.Error))
            }
           // Success
           if let data = data,
              let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let message = jsonResponse["data"] as? [String: String],
              let successMessage = message["message"] {
               DispatchQueue.main.async {
                   self.alertChangePassword?(successMessage)
               }
           }
           completion(.success(data))
       }.resume()
   }
}
