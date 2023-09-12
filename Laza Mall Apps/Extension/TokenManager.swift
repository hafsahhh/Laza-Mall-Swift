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
    
    // Fungsi untuk melakukan refresh token secara asynchronous
    static func refreshToken(refreshTokenKey: String) async -> Bool {
        // Membuat URL untuk permintaan
        guard let url = URL(string: Endpoints.Gets.refreshToken.url) else {
            return false
        }
        
        // Membuat permintaan URLRequest dengan menambahkan token ke header
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(refreshTokenKey)", forHTTPHeaderField: "X-Auth-Refresh")
        
        // Melakukan permintaan jaringan secara asynchronous
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
    

    // Fungsi untuk memeriksa apakah perlu melakukan refresh token atau tidak
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

// Enum yang mendefinisikan beberapa kasus error yang mungkin terjadi
enum APIServiceError: Error {
    case accessTokenNotFound
    case invalidURL
    // Add other error cases as needed
}
