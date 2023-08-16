//
//  ApiAllCategory.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 27/07/23.
//

import Foundation

class AllCategoryApi  {
    func getData(completion:@escaping (categoryIndex) -> ()) {
        guard let url = URL(string: "https://lazaapp.shop/brand") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let catList = try JSONDecoder().decode(categoryIndex.self, from: data)
                DispatchQueue.main.async {
                    completion(catList)
                }
            } catch {
                print("Error decoding data category: \(error)")
            }
        }.resume()
    }

//    func getData(completion: @escaping (categoryIndex) ->  ()) {
//        guard let url = URL(string: "https://lazaapp.shop/brand") else {
//            print("Invalid url")
//            return }
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data else { return }
//
//            do {
//                let categoryList = try JSONDecoder().decode(categoryIndex.self, from: data)
//                DispatchQueue.main.async {
//                    completion(categoryList)
//                }
//            } catch {
//                print("Error decoding data category: \(error)")
//            }
//        }.resume()
//    }
    
}
