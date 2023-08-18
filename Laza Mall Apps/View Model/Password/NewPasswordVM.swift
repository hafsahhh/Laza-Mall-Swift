//
//  NewPasswordVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 18/08/23.
//

import Foundation
class NewPasswordViewModel {
    func getCodeVerify(newPassword: String, rePassword: String, email: String, code: String,
                      completion: @escaping (Result<Data?, Error>) -> Void)//closure atau blok kode yang dapat dilewatkan ke fungsi sebagai parameter
   {
       let urlString = "https://lazaapp.shop/auth/recover/password?email=\(email)&code=\(code)"
       guard let url = URL(string: urlString) else { return }
       var request = URLRequest(url: url)
       request.httpMethod = "POST"
       request.httpBody = ApiService.getHttpBodyRaw(param: [
        "new_password": newPassword,
        "re_password": rePassword,
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
               print("respon verify email Api \(statusCode)")
               completion(.failure(newPasswordError.Error))
               return
           }
           // Success
           completion(.success(data))
       }.resume()
   }
}

enum newPasswordError: Error {
    case Error
}
