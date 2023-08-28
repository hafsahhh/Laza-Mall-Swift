//
//  ApiNewPassword.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 15/08/23.
//

import Foundation

class ApiNewPasswordService {
    static func getHttpBodyForm(param: [String:Any]) -> Data? {
        var body = [String]()
        param.forEach { (key, value) in
            body.append("\(key)=\(value)")
        }
        let bodyString = body.joined(separator: "&")
        return bodyString.data(using: .utf8)
    }
    static func getHttpBodyRaw(param: [String:Any]) -> Data?{
        let jsonData = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        return jsonData
    }
}

class ApiNewPassword {
    func getCodeVerify(newPassword: String, rePassword: String, email: String, code: String,
                      completion: @escaping (Result<Data?, Error>) -> Void)//closure atau blok kode yang dapat dilewatkan ke fungsi sebagai parameter
   {
       let urlString = "https://lazaapp.shop/auth/recover/password?email=\(email)&code=\(code)"
       guard let url = URL(string: urlString) else { return }
       var request = URLRequest(url: url)
       request.httpMethod = "POST"
       request.httpBody = ApiNewPasswordService.getHttpBodyRaw(param: [
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
               completion(.failure(ErrorInfo.Error))
               return
           }
           // Success
           completion(.success(data))
       }.resume()
   }
}

//enum newPasswordError: Error {
//    case Error
//}
