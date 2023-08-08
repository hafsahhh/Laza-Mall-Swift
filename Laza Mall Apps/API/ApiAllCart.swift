//
//  ApiAllCart.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 06/08/23.
//

import Foundation
import Foundation

typealias cartIndex = [CartElement]

class ApiAllCart  {

    func getData(completion: @escaping (cartIndex) -> Void) {
        guard let url = URL(string: "https://fakestoreapi.com/carts") else {
            print("Invalid url")
            return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }

            do {
                let cartList = try JSONDecoder().decode(cartIndex.self, from: data)
                DispatchQueue.main.async {
                    completion(cartList)
                    print("Api cart element: \(cartList)")
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
    
}
