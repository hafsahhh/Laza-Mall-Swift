//
//  ApiUsers.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 26/07/23.
//

import Foundation
class UserAllApi  {
    
    typealias UserIndex = [allUser]

    func getData(completion:@escaping (UserIndex) -> ()) {
        guard let url = URL(string: "https://fakestoreapi.com/users") else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }

            do {
                let userList = try JSONDecoder().decode(UserIndex.self, from: data)
                DispatchQueue.main.async {
                    completion(userList)
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
    
}
