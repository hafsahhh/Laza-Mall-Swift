//
//  CartsVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 23/08/23.
//

import Foundation

class CartsViewModel{
    
    var apiCarts: ((String, String) -> Void)? // Properti penutup untuk menangani respons API
    
    // MARK: - Fungsi untuk mengambil semua keranjang pengguna menggunakan API
    func getCarts(completion: @escaping(Result<CartResponse?, Error>) -> Void) {
        // Membuat URL untuk mendapatkan semua keranjang
        guard let url = URL(string: Endpoints.Gets.cartsAll.url) else {
            completion(.failure(ErrorInfo.Error))
            return
        }
        
        guard let accesToken = KeychainManager.shared.getAccessToken() else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        
        // Memulai permintaan HTTP untuk mengambil keranjang pengguna
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Menangani kesalahan jaringan
            if let error = error {
                print("Error: \(error)")
                completion(.failure(error))
                return
            }
            
            // Memeriksa apakah ada data yang dikembalikan dari API
            guard let data = data else {
                completion(.failure(ErrorInfo.Error))
                return
            }
            
            // Mendeserialisasi JSON respons
            do {
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(ErrorInfo.Error))
                    return
                }
                print("Kode status respons: \(httpResponse.statusCode)")
                
                // Mendekode JSON respons menjadi model CartResponse
                let productList = try JSONDecoder().decode(CartResponse.self, from: data)
                completion(.success(productList))
                
            } catch {
                //                print("Kesalahan dalam mendekode data: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    // MARK: - Fungsi untuk menghapus keranjang menggunakan API
    func deleteCarts(idProduct: Int, idSize: Int, completion: @escaping (Result<Data?, Error>) -> Void) {
        
        // Membuat URL untuk menghapus keranjang dengan menggunakan endpoint yang sesuai
        guard let url = URL(string: Endpoints.Gets.deleteCarts(idProduct: idProduct, idSize: idSize).url) else {
            return
        }
        
        guard let accesToken = KeychainManager.shared.getAccessToken() else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        
        // Memulai permintaan HTTP untuk menghapus keranjang
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Jika terjadi error, kirim error melalui completion handler
                completion(.failure(error))
                print("Terjadi kesalahan")
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
                            // Memanggil penanganan API
                            self.apiCarts?(status, data)
                        }
                        print("Error \(jsonResponse)")
                        return
                    }
                } else {
                    if let data = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let data = jsonResponse["data"] as? String,
                       let status = jsonResponse["status"] as? String {
                        DispatchQueue.main.async {
                            // Memanggil penanganan API
                            self.apiCarts?(status, data)
                        }
                    }
                    print("Berhasil menghapus produk")
                    completion(.success(data))
                }
            }
        }.resume()
    }
    
    
    // MARK: - Func Delete Cart using API
    func updateCarts(idProduct:Int, idSize: Int, completion: @escaping (Result<Data?, Error>) -> Void) {
        
        guard let url = URL(string: Endpoints.Gets.updateCarts(idProduct: idProduct, idSize: idSize).url) else
        {return}
        
        guard let accesToken = KeychainManager.shared.getAccessToken() else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
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
                        print("ERROR Update\(jsonResponse)")
                        return
                    }
                }else{
                    if let data = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let data = jsonResponse["data"] as? String,
                       let status = jsonResponse["status"] as? String {
                        DispatchQueue.main.async {
                            // Memanggil alert API
                            self.apiCarts?(status, data)
                        }
                        print("Succesfully update product\(jsonResponse)")
                    }
                    completion(.success(data))
                }
            }
        }.resume()
        
    }
    
    
    // MARK: - Func ArrowUp
    func arrowUpQuantityCart(idProduct: Int, idSize: Int,completion: @escaping (Result<Data?, Error>) -> Void) {
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
                        print("Error Update\(jsonResponse)")
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
                        print("Succesfully Add one product\(jsonResponse)")
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
    
    
    // MARK: - Func Post For Checkout Order
    func postDataOrder(product: [DataProduct], address_id: Int, bank: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        
        // Membuat URL untuk endpoint order
        guard let url = URL(string: Endpoints.Gets.order.url) else {
            completion(.failure(ErrorInfo.Error))
            return
        }
        
        // Mengambil access token dari Keychain
        guard let accessToken = KeychainManager.shared.getAccessToken() else { return }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "X-Auth-Token")
        request.httpMethod = "POST"
        
        do {
            let checkoutBody = CheckoutBody(products: product, addressId: address_id, bank: bank)
            let encoder = JSONEncoder()
            let json = try encoder.encode(checkoutBody)
            request.httpBody = json
        } catch {
            print("Error checkout JSON")
            return
        }
        
        
        // Melakukan permintaan HTTP
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if statusCode != 201 {
                    // Error: Menangani respons dengan status code yang tidak berhasil
                    print("Checkout Status Respons: \(statusCode)")
                    if let data = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let description = jsonResponse["description"] as? String,
                       let status = jsonResponse["status"] as? String {
                        
                        DispatchQueue.main.async {
                            // Memanggil penanganan respons API
                            self.apiCarts?(status, description)
                        }
                    }
                    completion(.failure(ErrorInfo.Error))
                } else {
                    // Sukses: Menangani respons berhasil
                    print("Berhasil checkout")
                    completion(.success(data))
                }
            }
        }.resume()
    }
}
