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
        
        // Membuat URL untuk endpoint code for verify
        guard let url = URL(string: Endpoints.Gets.codeForgot.url) else {
            completion(.failure(ErrorInfo.Error))
            return
        }
        
        
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
            if let statusCode = httpResponse?.statusCode, statusCode != 200 {
                // Error
                print("Response Status Code: \(statusCode)")
                if let data = data,
                   let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let description = jsonResponse["description"] as? String{
                    
                    DispatchQueue.main.async {
                        self.apiVerifyPassAlert?(description)
                    }
                }
                completion(.failure(ErrorInfo.Error))
             }
            // Success
            completion(.success(data))
        }.resume()
    }
}

