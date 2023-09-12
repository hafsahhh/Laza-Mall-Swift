//
//  CategoryBrandVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 20/08/23.
//

import Foundation

class CategoryBrandViewModel{
    // Fungsi untuk mengambil data produk berdasarkan merek (brand)
    func getDataBrandProductApi(name: String,completion: @escaping (productByIdBrandIndex) -> ()) {
        
        // Membuat URL berdasarkan nama merek (brand)
        guard let url = URL(string: Endpoints.Gets.brandProduct(nameBrand: name).url) else {return}

        // Melakukan permintaan HTTP dengan URLSession
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                // Membaca data JSON dan mendecode ke dalam model 'productByIdBrandIndex'
                let productList = try JSONDecoder().decode(productByIdBrandIndex.self, from: data)
                
                // Mengirimkan hasil pemrosesan ke dalam completion handler di main queue (thread)
                DispatchQueue.main.async {
                    completion(productList)
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
}
