//
//  ReviewProdVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 18/08/23.
//

import Foundation
class ReviewViewModel {
    
    func getDataReviewProduct(id: Int, completion:@escaping (ReviewAll) -> ()) {
        
        guard let url = URL(string: Endpoints.Gets.riview(id: id).url) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                guard let httpResponse = response as? HTTPURLResponse else { return }
                print("Status code review: \(httpResponse.statusCode)")
                print("Serisllized data")
                let serializedJson = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print(serializedJson)
                let productList = try JSONDecoder().decode(ReviewAll.self, from: data)
                completion(productList)
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
}
