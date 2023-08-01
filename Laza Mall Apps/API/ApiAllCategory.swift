//
//  ApiAllCategory.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 27/07/23.
//

import Foundation

typealias categoryIndex = [String]

class AllCategoryApi  {
    
//    typealias categoryIndex = [String]

    func getData(completion: @escaping (categoryIndex) -> Void) {
        guard let url = URL(string: "https://fakestoreapi.com/products/categories") else {
            print("Invalid url")
            return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }

            do {
                let categoryList = try JSONDecoder().decode(categoryIndex.self, from: data)
                DispatchQueue.main.async {
                    completion(categoryList)
                    print("APi CATEGORY BRAND: \(categoryList)")
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
    
}
