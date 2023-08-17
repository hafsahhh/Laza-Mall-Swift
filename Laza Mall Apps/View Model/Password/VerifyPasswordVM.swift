//
//  VerifyPasswordVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 17/08/23.
//

import Foundation

class VerifyPasswordViewModel {
    
    var apiVerifyPassAlert: ((String) -> Void)?
    
    func getCodeVerify(email: String, code: String,
                       completion: @escaping (Result<Data?, Error>) -> Void)//closure atau blok kode yang dapat dilewatkan ke fungsi sebagai parameter
    {
        let urlString = "https://lazaapp.shop/auth/recover/code"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = ApiService.getHttpBodyRaw(param: [
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
                print("Response Status Code: \(statusCode)")
                if let data = data,
                   let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let description = jsonResponse["description"] as? String{
                    
                    DispatchQueue.main.async {
                        self.apiVerifyPassAlert?(description)
                    }
                }
                completion(.failure(signUpError.Error))
             }
            // Success
            completion(.success(data))
        }.resume()
    }
}

enum verifyCodePassError: Error {
    case Error
}
