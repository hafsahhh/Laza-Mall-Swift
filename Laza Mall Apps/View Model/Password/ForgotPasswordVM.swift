//
//  ForgotPasswordVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 17/08/23.
//

import Foundation
class ForgotPasswordViewModel  {
    
    // Closure untuk menampilkan pesan alert ketika gagal
    var failedApiAlertForgotPassword: ((String) -> Void)?
    // Closure untuk menampilkan pesan alert ketika berhasil
    var succesAlerForgotPass: ((String) -> Void)?
    
    // Fungsi untuk mengirim permintaan lupa kata sandi berdasarkan email
    func getPassEmail(email: String,
                      completion: @escaping (Result<Data?, Error>) -> Void)//closure atau blok kode yang dapat dilewatkan ke fungsi sebagai parameter
   {

       // Membuat URL untuk endpoint forgot password
       guard let url = URL(string: Endpoints.Gets.forgotPassword.url) else {
           completion(.failure(ErrorInfo.Error))
           return
       }
       
       // Membuat permintaan HTTP
       var request = URLRequest(url: url)
       request.httpMethod = "POST"
       request.httpBody = ApiService.getHttpBodyRaw(param: [
           "email": email
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
                       // Menampilkan pesan alert ketika gagal
                       self.failedApiAlertForgotPassword?(description)
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
                   // Menampilkan pesan alert ketika berhasil
                   self.succesAlerForgotPass?(successMessage)
               }
           }
           completion(.success(data))
       }.resume()
   }
}

