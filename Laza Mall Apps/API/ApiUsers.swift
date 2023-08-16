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
    var apiAlertLogin: ((String, String) -> Void)?
    var apiAlertProfile : ((String) -> Void)?
    var token: String?
    
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
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if statusCode != 200 {
                    // Error
                    print("Response Status Code: \(statusCode)")
                    if let data = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let description = jsonResponse["description"] as? String,
                       let status = jsonResponse["status"] as? String,
                       let token = jsonResponse["access_token"] as? String {
                        DispatchQueue.main.async {
                            self.apiAlertLogin?(status, description)
                        }
                        self.token = token
                    }
                    completion(.failure(signUpError.Error))
                } else {
                    print("Response Status Code Benar: \(statusCode)")
                    if let data = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let data = jsonResponse["data"] as? [String: Any],
                       let token = data["access_token"] as? String {
                        DispatchQueue.main.async {
                            self.apiAlertProfile?(token)
                        }
                        print("Token user baru\(token)")
                        UserDefaults.standard.set(token, forKey: "access_token")
                    }
                    print("Sukses Login")
                    completion(.success(data))
                }
            }
        }.resume()
    }
    
    func getUserProfile(access_token: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        let urlString = "https://lazaapp.shop/user/profile"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        
//        let userApi = UserAllApi() // Buat instance baru dari UserAllApi
//
//        // Set header dengan token yang telah disimpan dalam instance userApi
//        if let token = userApi.token {
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
//            print("Token ini\(token)")
//        }
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "X-Auth-Token")
        URLSession.shared.dataTask(with: request){
            (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            let httpResponse = response as? HTTPURLResponse
            if let statusCode = httpResponse?.statusCode, statusCode != 200 {
                // Error
                print("respon get profile \(statusCode)")
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


