//
//  WishlistVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 21/08/23.
//

import Foundation


class WishlistViewModel {
    func getWishlistUser(completion: @escaping (Result<wishlistIndex, Error>) -> Void) {
        // Memastikan token autentikasi tersedia dalam UserDefaults
        
        guard let encodedToken = UserDefaults.standard.data(forKey: "auth_token"),
              let authToken = try? JSONDecoder().decode(AuthToken.self, from: encodedToken) else {
            // Jika token tidak tersedia atau gagal di-decode, kirim error
            completion(.failure(WishlistError.authenticationError))
            return
        }
        
        // URL endpoint untuk mengambil wishlist user pengguna
        let urlString = "https://lazaapp.shop/wishlists"
        
        // Memastikan URL valid
        guard let url = URL(string: urlString) else {
            // Jika URL tidak valid, kirim error
            completion(.failure(WishlistError.invalidURL))
            return
        }
        
        // Membuat permintaan URLRequest dengan menambahkan token ke header
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken.access_token)", forHTTPHeaderField: "X-Auth-Token")
        
        // Memulai permintaan HTTP untuk mengambil wishlist pengguna
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
                completion(.failure(WishlistError.invalidResponse))
                return
            }
            
            do {
                let userWishlist = try JSONDecoder().decode(wishlistIndex.self, from: data)
                completion(.success(userWishlist))
            } catch {
                completion(.failure(WishlistError.decodingError))
            }
        }.resume()
    }
}



enum WishlistError: Error {
    case authenticationError
    case invalidURL
    case invalidResponse
    case decodingError
    case requestFailed
}
