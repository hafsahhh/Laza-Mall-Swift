//
//  EditAddressVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 28/08/23.
//

import Foundation
class EditAddressViewModel {
    var apiAddressAlert: ((String) -> Void)?
    
    func updateAddress(idAddress: Int, country: String, city: String, receiverName: String, phoneNumber: String, isPrimary: Bool, completion: @escaping (Result<Data?, Error>) -> Void){
        print("update Data Address User")
        
        // Mengecek apakah token otentikasi pengguna tersedia dalam UserDefaults
        guard let encodedToken = UserDefaults.standard.data(forKey: "auth_token"),
              let authToken = try? JSONDecoder().decode(AuthToken.self, from: encodedToken) else {
            return
        }
        
        // Membuat URL untuk menghapus alamat dengan menggunakan endpoint yang sesuai
        guard let url = URL(string: Endpoints.Gets.updateAddresss(idAddress: idAddress).url) else {
            return
        }
        
        // Menyiapkan permintaan dengan metode HTTP DELETE dan token otentikasi
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(authToken.access_token)", forHTTPHeaderField: "X-Auth-Token")
        request.httpBody = ApiService.getHttpBodyRaw(param: [
            "country": country,
            "city": city,
            "receiver_name": receiverName,
            "phone_number": phoneNumber,
            "is_primary": isPrimary
        ])
        
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
                        print("error update address \(jsonResponse)")
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
                    print("success update address")
                    completion(.success(data))
                }
            }
        }.resume()
    }
}
