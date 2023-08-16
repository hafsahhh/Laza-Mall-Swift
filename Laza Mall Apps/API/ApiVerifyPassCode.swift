
//  ApiVerifyPassCode.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 15/08/23.


import Foundation
class ApiPaswordCodeService {
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

class ApiVerifyPassCode {
    func getCodeVerify(email: String, code: String,
                      completion: @escaping (Result<Data?, Error>) -> Void)//closure atau blok kode yang dapat dilewatkan ke fungsi sebagai parameter
   {
       let urlString = "https://lazaapp.shop/auth/recover/code"
       guard let url = URL(string: urlString) else { return }
       var request = URLRequest(url: url)
       request.httpMethod = "POST"
       request.httpBody = ApiPaswordCodeService.getHttpBodyRaw(param: [
        "email" : email,
        "code": code
       ])

       URLSession.shared.dataTask(with: request){
           (data, response, error) in
           if let error = error {
               print(error)
               return
           }
           let httpResponse = response as? HTTPURLResponse
           if let statusCode = httpResponse?.statusCode, statusCode != 202 {
               // Error
               print("respon forgot password Api \(statusCode)")
               completion(.failure(verifyCodePassError.Error))
               return
           }
           // Success
           completion(.success(data))
       }.resume()
   }
}

enum verifyCodePassError: Error {
    case Error
}
