//
//  ProfileVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 21/08/23.
//

import Foundation
class ProfileViewModel {
    
    var apiAlertProfile: ((String, String) -> Void)?
    var token: String?
    
    func updateProfile(fullName: String, username: String, email: String, media: Media?,
                    completion: @escaping (String) -> Void, onError: @escaping(String) -> Void) {
        
        guard let encodedToken = UserDefaults.standard.data(forKey: "auth_token"),
              let authToken = try? JSONDecoder().decode(AuthToken.self, from: encodedToken) else {
            return
        }
        
        guard let url = URL(string: Endpoints.Gets.updateProfile.url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(authToken.access_token)", forHTTPHeaderField: "X-Auth-Token")
        
        
        let boundary = ApiService.getBoundary()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = ApiService.getApiByFormData(
            withParameters: [
                "full_name": fullName,
                "username": username,
                "email": email
            ],
            media: media,
            boundary: boundary)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpRespon = response as? HTTPURLResponse else { return }
            guard let data = data else { return }
            print(httpRespon.statusCode)
            
            do {
                let serializedJson = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print(serializedJson)
                
                if httpRespon.statusCode == 200,
                   let jsonResponse = serializedJson as? [String: Any],
                   let description = jsonResponse["description"] as? String,
                   let status = jsonResponse["status"] as? String {
                    DispatchQueue.main.async {
                        // Memanggil alert API
                        self.apiAlertProfile?(status, description)
                    }
                    print("INI PROFILE\(jsonResponse)")
                } else {
                    print("Error: \(httpRespon.statusCode)")
                    if let jsonResponse = serializedJson as? [String: Any],
                       let description = jsonResponse["description"] as? String,
                       let status = jsonResponse["status"] as? String {
                        DispatchQueue.main.async {
                            // Memanggil alert API
                            self.apiAlertProfile?(status, description)
                        }
                        print("INI PROFILE\(jsonResponse)")
                    }
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}










//    func updateProfileUser(username: String, fullname: String, email: String,
//                      completion: @escaping (Result<EditProfile?, Error>) -> Void) {
//
//        guard let encodedToken = UserDefaults.standard.data(forKey: "auth_token"),
//              let authToken = try? JSONDecoder().decode(AuthToken.self, from: encodedToken) else {
//            // Jika token tidak tersedia atau gagal di-decode, kirim error
//            completion(.failure(LoginError.Error))
//            return
//        }
//
//        // URL endpoint untuk mengambil profil pengguna
//        let urlString = "https://lazaapp.shop/user/update"
//
//        // Memastikan URL valid
//        guard let url = URL(string: urlString) else {
//            // Jika URL tidak valid, kirim error
//            completion(.failure(LoginError.Error))
//            return
//        }
//
//        // Membuat permintaan URLRequest dengan menambahkan token ke header
//        var request = URLRequest(url: url)
//        request.httpMethod = "PUT"
//        request.setValue("Bearer \(authToken.access_token)", forHTTPHeaderField: "X-Auth-Token")
//
//        let formData = [
//            "username": username,
//            "full_name": fullname,
//            "email": email
//        ]
//
//        request.httpBody = ApiService.getHttpBodyForm(param: formData)
//
////        // Create a query string from the form data
////        let formDataString = formData.map { (key, value) in
////            return "\(key)=\(value)"
////        }.joined(separator: "&")
////
////        // Set the HTTP body with the form data
////        request.httpBody = formDataString.data(using: .utf8)
////        print("httpbody\(String(describing: request.httpBody))")
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                // Jika terjadi error, kirim error melalui completion handler
//                completion(.failure(error))
//                return
//            }
//
//            if let httpResponse = response as? HTTPURLResponse {
//                let statusCode = httpResponse.statusCode
//                if statusCode != 200 {
//                    // Jika status code tidak 200, coba mengekstrak informasi dari response
//                    if let data = data,
//                       let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                       let description = jsonResponse["description"] as? String,
//                       let status = jsonResponse["status"] as? String {
//                        DispatchQueue.main.async {
//                            // Memanggil alert API
//                            self.apiAlertProfile?(status, description)
//                        }
//                        print("INI PROFILE\(jsonResponse)")
//                    }
//                    // Jika terjadi error saat login, kirim error melalui completion handler
//                    completion(.failure(LoginError.Error))
//                } else {
//                    if let data = data {
//                        if let editProfileResponse = try? JSONDecoder().decode(EditProfileResponse.self, from: data),
//                           editProfileResponse.status == "OK",
//                           !editProfileResponse.isError {
//                            if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                               let responseData = jsonResponse["data"] as? String,
//                               let status = jsonResponse["status"] as? String {
//                                DispatchQueue.main.async {
//                                    // Memanggil alert API
//                                    self.apiAlertProfile?(status, responseData)
//                                }
//                            }
//                            // Menyampaikan hasil berhasil melalui completion handler
//                            completion(.success(editProfileResponse.data))
//                        } else {
//                            // Jika terjadi error saat login, kirim error melalui completion handler
//                            completion(.failure(LoginError.Error))
//                        }
//                    }
//
//                }
//            }
//        }.resume()
//    }

