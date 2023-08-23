//
//  CartsVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 23/08/23.
//

import Foundation

class CartsViewModel{
    
    var apiCarts: ((String, String) -> Void)?
    
    // MARK: - Func get all carts user using API
    func getCarts(completion: @escaping(Result<CartResponse?, Error>) -> Void) {
        
        guard let encodedToken = UserDefaults.standard.data(forKey: "auth_token"),
              let authToken = try? JSONDecoder().decode(AuthToken.self, from: encodedToken) else {
            // Jika token tidak tersedia atau gagal di-decode, kirim error
            completion(.failure(LoginError.Error))
            return
        }
        
        guard let url = URL(string: Endpoints.Gets.cartsAll.url) else {return}
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken.access_token)", forHTTPHeaderField: "X-Auth-Token")
        
        
        // Memulai permintaan HTTP untuk mengambil carts pengguna
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
                completion(.failure(LoginError.Error))
                return
            }
            
            do {
                let userWishlist = try JSONDecoder().decode(CartResponse.self, from: data)
                completion(.success(userWishlist))
            } catch {
                completion(.failure(LoginError.Error))
            }
        }.resume()
    }
    
    // MARK: - Func Delete Cart using API
    func deleteCarts(idProduct:Int, idSize: Int, completion: @escaping (Result<Data?, Error>) -> Void) {
        print("Delete Data carts")
        guard let encodedToken = UserDefaults.standard.data(forKey: "auth_token"),
              let authToken = try? JSONDecoder().decode(AuthToken.self, from: encodedToken) else {
            return
        }
        
        guard let url = URL(string: Endpoints.Gets.deleteCarts(idProduct: idProduct, idSize: idSize).url) else
        {return}
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(authToken.access_token)", forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Jika terjadi error, kirim error melalui completion handler
                completion(.failure(error))
                print("error")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if statusCode != 200 {
                    // Jika status code tidak 200, coba mengekstrak informasi dari response
                    if let data = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let data = jsonResponse["data"] as? String,
                       let status = jsonResponse["status"] as? String {
                        DispatchQueue.main.async {
                            // Memanggil alert API
                            self.apiCarts?(status, data)
                        }
                        print("INI ERROR\(jsonResponse)")
                        return
                    }
                    if let data = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let data = jsonResponse["data"] as? String,
                       let status = jsonResponse["status"] as? String {
                        DispatchQueue.main.async {
                            // Memanggil alert API
                            self.apiCarts?(status, data)
                        }
                        print("Succesfully delete product\(jsonResponse)")
                    }
                    completion(.success(data))
                }
            }
        }.resume()
        
    }
    
    // MARK: - Func Get All Size
    func getSizeAll(completion:@escaping (AllSize) -> ()) {
        guard let url = URL(string: Endpoints.Gets.sizeAll.url) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let sizeList = try JSONDecoder().decode(AllSize.self, from: data)
                DispatchQueue.main.async {
                    completion(sizeList)
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
    
}
