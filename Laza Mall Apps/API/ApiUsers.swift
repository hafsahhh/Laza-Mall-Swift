//
//  ApiUsers.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 26/07/23.
//

import Foundation
class ApiLoginService {
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

class UserAllApi  {
    func getDataLogin(username: String,
                      password: String,
                      completion: @escaping (Result<Data?, Error>) -> Void)//closure atau blok kode yang dapat dilewatkan ke fungsi sebagai parameter
   {
       let urlString = "https://lazaapp.shop/login"
       guard let url = URL(string: urlString) else { return }
       var request = URLRequest(url: url)
       request.httpMethod = "POST"
       request.httpBody = ApiLoginService.getHttpBodyRaw(param: [
           "username": username,
           "password": password
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
               print("respon login Api \(statusCode)")
               completion(.failure(LoginError.Error))
               return
           }
           // Success
           completion(.success(data))
       }.resume()
   }
}

enum LoginError: Error {
    case Error
}

