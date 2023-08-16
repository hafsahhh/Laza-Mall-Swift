//
//  ApiSignUp.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 14/08/23.
//

import Foundation

class ApiSignService {
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

class ApiSignUp{
    
    var apiAlertSIgnUp: ((String, String) -> Void)?
    // MARK: - Func signUpUserAPI
    
    func signUpUserAPI(username: String,
                       email: String,
                       password: String,
                       completion: @escaping (Result<Data?, Error>) -> Void)//closure atau blok kode yang dapat dilewatkan ke fungsi sebagai parameter
    {
        let urlString = "https://lazaapp.shop/register"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = ApiSignService.getHttpBodyRaw(param: [
            "full_name": username,
            "username": username,
            "email": email,
            "password": password
        ])
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if statusCode != 201 {
                    // Error
                    print("Response Status Code: \(statusCode)")
                    if let data = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let description = jsonResponse["description"] as? String,
                       let status = jsonResponse["status"] as? String{
                        
                        DispatchQueue.main.async {
                            self.apiAlertSIgnUp?(status, description)
                        }
                    }
                    completion(.failure(signUpError.Error))
                } else {
                    print("Sukses signUp")
                    // Success
                    completion(.success(data))
                }
            }
        }.resume()
    }
}

enum signUpError: Error {
    case Error
}
