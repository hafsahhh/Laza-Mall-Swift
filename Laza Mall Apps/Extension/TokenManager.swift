//
//  TokenManager.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 01/09/23.
//

import Foundation
import JWTDecode

class ApiRefreshToken {
    
    let token = KeychainManager.shared.getAccessToken()
    let refToken = KeychainManager.shared.getRefreshToken()
    
//    func apiRefreshToken(completion: @escaping (Result<Data?, Error>) -> Void) {
//        // Memastikan token autentikasi tersedia dalam UserDefaults
//
//        guard let refreshToken = KeychainManager.shared.getRefreshToken() else {
//            print("kosong") // Cetak pesan "kosong" jika refreshToken tidak tersedia
//            return
//        }
//
//        guard let url = URL(string: Endpoints.Gets.refreshToken.url) else {
//            completion(.failure(ErrorInfo.Error)) // Jika URL tidak valid, kirim error melalui completion handler
//            return
//        }
//
//        // Membuat permintaan URLRequest dengan menambahkan token ke header
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "X-Auth-Refresh")
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                // Jika terjadi error, kirim error melalui completion handler
//                completion(.failure(error))
//                return
//            }
//            guard let httpResponse = response as? HTTPURLResponse else { return }
//            // Gagal
//            let statusCode = httpResponse.statusCode
//            if statusCode != 200 {
//                // Jika status code tidak 200, coba mengekstrak informasi dari response
//                print("error \(statusCode)") // Cetak kode status error
//                // Jika terjadi error saat refreshToken, kirim error melalui completion handler
//                completion(.failure(ErrorInfo.Error))
//                return
//            }
//            // Berhasil
//            if let data = data,
//               let refreshResponse = try? JSONDecoder().decode(refreshTokenResponse.self, from: data),
//               refreshResponse.status == "OK"{
//
//                KeychainManager.shared.saveAccessToken(token: refreshResponse.data.access_token)
//                KeychainManager.shared.saveRefreshToken(token: refreshResponse.data.refresh_token)
//                print("Access Token Terbaru: \(refreshResponse.data.access_token)") // Menampilkan access token
//                print("refresh Token Terbaru: \(refreshResponse.data.refresh_token)")
//
//                // Menyampaikan hasil berhasil melalui completion handler
//                completion(.success(data))
//            } else {
//                // Jika terjadi error saat refresh token, kirim error melalui completion handler
//                completion(.failure(ErrorInfo.Error))
//            }
//        }.resume()
//    }
    
    static func refreshToken(refreshTokenKey: String) async -> Bool {
        // Construct the URL
        guard let url = URL(string: Endpoints.Gets.refreshToken.url) else {
            return false
        }
        
        // Membuat permintaan URLRequest dengan menambahkan token ke header
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(refreshTokenKey)", forHTTPHeaderField: "X-Auth-Refresh")
        
        // Perform the network request asynchronously
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else { return false }
            if httpResponse.statusCode != 200 {
                throw "Error: \(httpResponse.statusCode)" as! LocalizedError
            }
            let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
            if let data = result?["data"] as? [String: Any],
               let accessToken = data["access_token"] as? String,
               let refreshToken = data["refresh_token"] as? String
            {
                KeychainManager.shared.saveAccessToken(token: accessToken)
                KeychainManager.shared.saveRefreshToken(token: refreshToken)
                print("Access Token Terbaru: \(accessToken)") // Menampilkan access token
                print("refresh Token Terbaru: \(refreshToken)")
            } else {
                throw APIServiceError.accessTokenNotFound
            }
            return true
        } catch {
            print("Refresh token error: ", error.localizedDescription)
            return false
        }
    }
    

    func refreshTokenIfNeeded(completion: @escaping () -> Void, onError: ((String) -> Void)?) {
        guard let refreshToken = KeychainManager.shared.getRefreshToken() else {
            print("kosong") // Cetak pesan "kosong" jika refreshToken tidak tersedia
            return
        }
        // Cek apakah token expired
        guard let jwt = try? decode(jwt: token!) else { return }
        if !jwt.expired { // jika tidak expired, run completion
            completion()
            return
        }
        // kalo expired, refresh dulu baru run completion
        Task {
            let isSuccess = await ApiRefreshToken.refreshToken(refreshTokenKey: refreshToken)
            isSuccess ? completion() : onError?("Error refresh token")
        }
    }

}

enum APIServiceError: Error {
    case accessTokenNotFound
    case invalidURL
    // Add other error cases as needed
}
