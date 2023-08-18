//
//  DetailProductVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 18/08/23.
//

import Foundation
class DetailProductViewModel {
    
    func getDataDetailProduct(id: Int, completion:@escaping (ProductDetailIndex) -> ()) {
        print("producrId: \(id)")
        guard let url = URL(string: "https://lazaapp.shop/products/\(id)") else { return }
        
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
}
