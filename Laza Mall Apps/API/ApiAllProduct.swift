//
//  ApiAllProduct.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 26/07/23.
//

import Foundation
class AllProductApi  {
    
    typealias ProductIndex = [ProductEntry]

    func getData(completion:@escaping (ProductIndex) -> ()) {
        guard let url = URL(string: "https://fakestoreapi.com/products") else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }

            do {
                let productList = try JSONDecoder().decode(ProductIndex.self, from: data)
                DispatchQueue.main.async {
                    completion(productList)
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
    

}




