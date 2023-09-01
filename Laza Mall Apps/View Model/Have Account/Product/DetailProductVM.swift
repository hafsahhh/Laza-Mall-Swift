//
//  DetailProductVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 18/08/23.
//

import Foundation
class DetailProductViewModel {
    
    var apiAlertDetailProduct: ((String, String) -> Void)?
    var apiAlertMessage: ((String) -> Void)?
    
    func getDataDetailProduct(id: Int, completion:@escaping (ProductDetailIndex) -> ()) {
        print("producrId: \(id)")
        
        guard let url = URL(string: Endpoints.Gets.producDetail(id: id).url) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                guard let httpResponse = response as? HTTPURLResponse else { return }
                print("Status code: \(httpResponse.statusCode)")
                print("Serisllized data")
                let serializedJson = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print(serializedJson)
                let productList = try JSONDecoder().decode(ProductDetailIndex.self, from: data)
                completion(productList)
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
    
    // MARK: - Func PUT Wihslist using API
    func putWishlistUser(productId: Int, completion: @escaping (Result<UpdateWishlist, Error>) -> Void) {

        guard let url = URL(string: Endpoints.Gets.addWishList(idProduct: productId).url) else {return}
        
        guard let accesToken = KeychainManager.shared.getAccessToken() else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        
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
                       let data = jsonResponse["data"] as? String,
                       let status = jsonResponse["status"] as? String {
                        DispatchQueue.main.async {
                            // Memanggil alert API
                            self.apiAlertDetailProduct?(status, data)
                        }
                        print("Update Wishlist\(jsonResponse)")
                    }
                    // Jika terjadi error saat login, kirim error melalui completion handler
                    completion(.failure(ErrorInfo.Error))
                } else {
                    if let data = data {
                        if let putWishlistResponse = try? JSONDecoder().decode(UpdateWishlist.self, from: data),
                           putWishlistResponse.status == "OK",
                           !putWishlistResponse.isError {
                            if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                               let responseData = jsonResponse["data"] as? String,
                               let status = jsonResponse["status"] as? String {
                                DispatchQueue.main.async {
                                    // Memanggil alert API
                                    self.apiAlertDetailProduct?(status, responseData)
                                }
                            }
                            // Menyampaikan hasil berhasil melalui completion handler
                            completion(.success(putWishlistResponse))
                        } else {
                            // Jika terjadi error saat login, kirim error melalui completion handler
                            completion(.failure(ErrorInfo.Error))
                        }
                    }
                    
                }
            }
        }.resume()
        
    }
    
    // MARK: - Func Add Cart using API
    func addCarts(idProduct:Int, idSize: Int, completion: @escaping (Result<Data?, Error>) -> Void) {
        
        guard let url = URL(string: Endpoints.Gets.addCarts(idProduct: idProduct, idSize: idSize).url) else
        {return}
        
        guard let accesToken = KeychainManager.shared.getAccessToken() else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Jika terjadi error, kirim error melalui completion handler
                completion(.failure(error))
                print("error")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if statusCode != 201 {
                    // Jika status code tidak 200, coba mengekstrak informasi dari response
                    if let data = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let data = jsonResponse["data"] as? String,
                       let status = jsonResponse["status"] as? String {
                        DispatchQueue.main.async {
                            // Memanggil alert API
                            self.apiAlertDetailProduct?(status, data)
                        }
                        print("INI ERROR\(jsonResponse)")
                        return
                    }
                }
                completion(.success(data))
            }
        }.resume()
        
    }
}
