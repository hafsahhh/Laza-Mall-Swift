//
//  ForgotPasswordVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 17/08/23.
//

import Foundation
class ForgotPasswordViewModel  {
    var failedApiAlertForgotPassword: ((String) -> Void)?
    var succesAlerForgotPass: ((String) -> Void)?
    
    func getPassEmail(email: String,
                      completion: @escaping (Result<Data?, Error>) -> Void)//closure atau blok kode yang dapat dilewatkan ke fungsi sebagai parameter
   {
       let urlString = "https://lazaapp.shop/auth/forgotpassword"
       guard let url = URL(string: urlString) else { return }
       var request = URLRequest(url: url)
       request.httpMethod = "POST"
       request.httpBody = ApiService.getHttpBodyRaw(param: [
           "email": email
       ])
       
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
                       self.failedApiAlertForgotPassword?(description)
                   }
               }
               completion(.failure(signUpError.Error))
            }
           // Success
           if let data = data,
              let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let message = jsonResponse["data"] as? [String: String],
              let successMessage = message["message"] {
               DispatchQueue.main.async {
                   self.succesAlerForgotPass?(successMessage)
               }
           }
           completion(.success(data))
       }.resume()
   }
}

enum ForgotPassError: Error {
    case Error
}
