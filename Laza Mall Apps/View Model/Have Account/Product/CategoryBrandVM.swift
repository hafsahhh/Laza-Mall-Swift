//
//  CategoryBrandVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 20/08/23.
//

import Foundation

class CategoryBrandViewModel{
    func getDataBrandProductApi(name: String,completion: @escaping (productByIdBrandIndex) -> ()) {
        print("Brand Name: \(name)")
        guard let url = URL(string: "https://lazaapp.shop/products/brand?name=\(name)") else { return }

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


//class CategoryBrandViewModel {
//    func getDataBrandProductApi(name: String, completion: @escaping (Result<[prudctByIdBrandResponse], Error>) -> ()) {
//        guard let url = URL(string: "https://lazaapp.shop/products/brand?name=\(name)") else {
//            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
//            return
//        }
//
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
//                return
//            }
//
//
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//
//                // Decode JSON into a dictionary
//                if let serializedJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    // Access the key that holds the array of products
//                    if let productsArray = serializedJson["data"] as? [[String: Any]] {
//                        // Decode the array of products using the appropriate model
//                        let responseData = try decoder.decode([prudctByIdBrandResponse].self, from: JSONSerialization.data(withJSONObject: productsArray))
//                        print(responseData)
//                        completion(.success(responseData))
//                    } else {
//                        completion(.failure(NSError(domain: "Unexpected JSON format", code: 0, userInfo: nil)))
//                    }
//                }
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//}
