//
//  LoginVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 13/08/23.
//

import Foundation

class LoginViewModel{
    var apiAlertLogin: ((String, String) -> Void)?
    var apiAlertProfile : ((String) -> Void)?
//    var token: String?
    
    func getDataLogin(username: String,
                      password: String,
                      completion: @escaping (Result<Data?, Error>) -> Void) {
        
        
        // Membuat URL untuk endpoint login
        guard let url = URL(string: Endpoints.Gets.login.url) else {
            completion(.failure(ErrorInfo.Error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = ApiService.getHttpBodyRaw(param: [
            "username": username,
            "password": password
        ])
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Jika terjadi error, kirim error melalui completion handler
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if statusCode != 200 {
                    // Jika status code tidak 200, coba mengekstrak informasi dari response
                    if let data = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let description = jsonResponse["description"] as? String,
                       let status = jsonResponse["status"] as? String {
                        DispatchQueue.main.async {
                            // Memanggil alert API
                            self.apiAlertLogin?(status, description)
                        }
                    }
                    // Jika terjadi error saat login, kirim error melalui completion handler
                    completion(.failure(ErrorInfo.Error))
                } else {
                    if let data = data,
                       let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data),
                       loginResponse.status == "OK",
                       !loginResponse.isError {

                        KeychainManager.shared.saveAccessToken(token: loginResponse.data.access_token)
                        KeychainManager.shared.saveRefreshToken(token: loginResponse.data.refresh_token)
                        print("Access Token: \(loginResponse.data.access_token)") // Menampilkan access token
                        print("refresh Token: \(loginResponse.data.refresh_token)")

                        
                        
                        // Menyampaikan hasil berhasil melalui completion handler
                        completion(.success(data))
                    } else {
                        // Jika terjadi error saat login, kirim error melalui completion handler
                        completion(.failure(ErrorInfo.Error))
                    }
                }
            }
        }.resume()
    }
    
    
    
    func getUserProfile(completion: @escaping (Result<DataUseProfile?, Error>) -> Void) {
        // Memastikan token autentikasi tersedia dalam UserDefaults

        guard let url = URL(string: Endpoints.Gets.profile.url) else {return}
        
        // Membuat permintaan URLRequest dengan menambahkan token ke header
        guard let accesToken = KeychainManager.shared.getAccessToken() else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        
        // Memulai permintaan HTTP untuk mengambil profil pengguna
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Jika terjadi error saat permintaan, kirim error
                completion(.failure(error))
                return
            }
            
            // Memastikan respons adalah HTTPURLResponse dan kode status 200 (sukses)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let data = data else {
                // Jika respons tidak valid, kirim error
                completion(.failure(ErrorInfo.Error))
                return
            }
            
            do {
                // Mendekode data JSON respons ke dalam tipe DataUseProfile
                let userProfile = try JSONDecoder().decode(profileUser.self, from: data)
                // Mengirim hasil yang berhasil kepada completion handler
                completion(.success(userProfile.data))
            } catch {
                // Jika terjadi kesalahan dekode maka akan kirim error
                completion(.failure(error))
            }
        }.resume()
    }
    
    
}

//// Jika login berhasil, menyimpan token ke UserDefaults
//let authToken: AuthToken = AuthData(access_token: loginResponse.data.access_token, refresh_token: loginResponse.data.refresh_token)
//if let encodedToken = try? JSONEncoder().encode(authToken) {
//    UserDefaults.standard.set(encodedToken, forKey: "auth_token")
//    print("Access Token: \(loginResponse.data.access_token)") // Menampilkan access token
////                            print("refresh Token: \(loginResponse.data.refresh_token)")
//}

