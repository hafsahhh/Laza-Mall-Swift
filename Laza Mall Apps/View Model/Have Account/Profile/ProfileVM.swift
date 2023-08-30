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
            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else { return }
            print(httpRespon.statusCode)
            if httpRespon.statusCode == 200 {
                do {
                    //untuk liat bentuk JSON
                    let serializedJson = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print(serializedJson)
                    let result = try JSONDecoder().decode(ResponFailed.self, from: data)
                    completion(result.status)
                    print("Helowoy")
                } catch {
                    print(error)
                }
            }  else {
                print("Error: \(httpRespon.statusCode)")
                guard let getFailed = try? JSONDecoder().decode(ResponFailed.self, from: data) else { return }
                onError(getFailed.description)
                print(getFailed.description)
            }
        }
        task.resume()
    }
}

