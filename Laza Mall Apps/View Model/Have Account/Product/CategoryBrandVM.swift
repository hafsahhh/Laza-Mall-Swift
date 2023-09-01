//
//  CategoryBrandVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 20/08/23.
//

import Foundation

class CategoryBrandViewModel{
    func getDataBrandProductApi(name: String,completion: @escaping (productByIdBrandIndex) -> ()) {
        
        guard let url = URL(string: Endpoints.Gets.brandProduct(nameBrand: name).url) else {return}

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let productList = try JSONDecoder().decode(productByIdBrandIndex.self, from: data)
                DispatchQueue.main.async {
                    completion(productList)
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
}
