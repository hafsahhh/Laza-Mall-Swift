//
//  AddressVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 24/08/23.
//

import Foundation

class AddressViewModel {
    
    var apiAddress: ((String, String) -> Void)? // Penutup untuk menangani respons API
    
    // MARK: - Fungsi untuk menambahkan alamat baru
    func addAddressUser(country: String, city: String, receiverName: String, phoneNumber: String, isPrimary: Bool,completion: @escaping (Result<Data?, Error>) -> Void)
    
    {
        // Memastikan token autentikasi tersedia dalam UserDefaults
        guard let encodedToken = UserDefaults.standard.data(forKey: "auth_token"),
              let authToken = try? JSONDecoder().decode(AuthToken.self, from: encodedToken) else {
            // Jika token tidak tersedia atau gagal di-decode, kirim error
            completion(.failure(ErrorInfo.Error))
            return
        }
        
        // Membuat URL untuk menambahkan alamat baru
        guard let url = URL(string: Endpoints.Gets.addAddress.url) else {
            completion(.failure(ErrorInfo.Error))
            return
        }
        
        // Mempersiapkan permintaan dengan metode HTTP POST dan body data
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken.access_token)", forHTTPHeaderField: "X-Auth-Token")
        request.httpMethod = "POST"
        request.httpBody = ApiService.getHttpBodyRaw(param: [
            "country": country,
            "city": city,
            "receiver_name": receiverName,
            "phone_number": phoneNumber,
            "is_primary": isPrimary
        ])
        
        // Memulai permintaan HTTP untuk menambahkan alamat baru
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if statusCode != 201 {
                    // Error: Menangani respons dengan status code yang tidak berhasil
                    print("Kode Status Respons: \(statusCode)")
                    if let data = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let description = jsonResponse["description"] as? String,
                       let status = jsonResponse["status"] as? String {
                        
                        DispatchQueue.main.async {
                            // Memanggil penanganan respons API
                            self.apiAddress?(status, description)
                        }
                    }
                    completion(.failure(ErrorInfo.Error))
                } else {
                    // Sukses: Menangani respons berhasil
                    print("Berhasil Add new Address Api")
                    completion(.success(data))
                }
            }
        }.resume()
    }
    
}

