//
//  ListAddressVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 24/08/23.
//

import Foundation

class ListAddressViewModel {
    
    var apiAddressAlert : ((String) -> Void)? // Properti penutup untuk menangani respons API
    
    func getAddressUser(completion: @escaping (Result<ResponseAllAddress?, Error>) -> Void) {
        // Memastikan token autentikasi tersedia dalam UserDefaults
        
        guard let url = URL(string: Endpoints.Gets.addressAll.url) else {
            completion(.failure(ErrorInfo.Error))
            return
        }
        guard let accesToken = KeychainManager.shared.getAccessToken() else { return }
        // Membuat permintaan URLRequest dengan menambahkan token ke header
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        
        // Memulai permintaan HTTP untuk mengambil address pengguna
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
                let userAddress = try JSONDecoder().decode(ResponseAllAddress?.self, from: data)
                completion(.success(userAddress))
            } catch {
                completion(.failure(ErrorInfo.Error))
            }
        }.resume()
    }
    
    
    func deleteAddress(idAddress: Int, completion: @escaping (Result<Data?, Error>) -> Void){
        
        // Membuat URL untuk menghapus alamat dengan menggunakan endpoint yang sesuai
        guard let url = URL(string: Endpoints.Gets.deleteAddress(idAddress: idAddress).url) else {
            return
        }
        guard let accesToken = KeychainManager.shared.getAccessToken() else { return }
        // Menyiapkan permintaan dengan metode HTTP DELETE dan token otentikasi
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
                       let data = jsonResponse["data"] as? String {
                        DispatchQueue.main.async {
                            // Memanggil penanganan API
                            self.apiAddressAlert?(data)
                        }
                        print("INI ERROR Address \(jsonResponse)")
                        return
                    }
                    if let data = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let data = jsonResponse["data"] as? String {
                        DispatchQueue.main.async {
                            // Memanggil penanganan API
                            self.apiAddressAlert?(data)
                        }
                    }
                    print("Berhasil menghapus address")
                    completion(.success(data))
                }
            }
        }.resume()
    }
    

    
}
