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
        
        guard let url = URL(string: Endpoints.Gets.wishlistAll.url) else {
            completion(.failure(ErrorInfo.Error))
            return
        }
        
        guard let accesToken = KeychainManager.shared.getAccessToken() else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        
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
                completion(.failure(ErrorInfo.Error))
                return
            }
            
            do {
                let userWishlist = try JSONDecoder().decode(wishlistIndex.self, from: data)
                completion(.success(userWishlist))
            } catch {
                completion(.failure(ErrorInfo.Error))
            }
        }.resume()
    }
}
