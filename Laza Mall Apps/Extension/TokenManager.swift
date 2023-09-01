//
//  TokenManager.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 01/09/23.
//

import Foundation
class ApiRefreshToken {
    
    func apiRefreshToken(completion: @escaping (Result<Data?, Error>) -> Void) {
        // Memastikan token autentikasi tersedia dalam UserDefaults
        
        guard let refreshToken = KeychainManager.shared.getRefreshToken() else {
            print("kosong")
            return }
        
        guard let url = URL(string: Endpoints.Gets.refreshToken.url) else {
            completion(.failure(ErrorInfo.Error))
            return
        }
        
        // Membuat permintaan URLRequest dengan menambahkan token ke header
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "X-Auth-Refresh")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Jika terjadi error, kirim error melalui completion handler
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else { return }
            // Gagal
            let statusCode = httpResponse.statusCode
            if statusCode != 200 {
                // Jika status code tidak 200, coba mengekstrak informasi dari response
                print("error \(statusCode)")
                // Jika terjadi error saat refreshToken, kirim error melalui completion handler
                completion(.failure(ErrorInfo.Error))
                return
            }
            // Berhasil
            if let data = data,
               let refreshResponse = try? JSONDecoder().decode(refreshTokenResponse.self, from: data),
               refreshResponse.status == "OK"{
                
                KeychainManager.shared.saveAccessToken(token: refreshResponse.data.access_token)
                KeychainManager.shared.saveRefreshToken(token: refreshResponse.data.refresh_token)
                print("Access Token Terbaru: \(refreshResponse.data.access_token)") // Menampilkan access token
                print("refresh Token Terbaru: \(refreshResponse.data.refresh_token)")

                // Menyampaikan hasil berhasil melalui completion handler
                completion(.success(data))
            } else {
                // Jika terjadi error saat refresh token, kirim error melalui completion handler
                completion(.failure(ErrorInfo.Error))
            }
        }.resume()
    }
}
