//
//  HomeViewModel.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 11/08/23.
//

import Foundation
import UIKit

class HomeViewModel{

    weak var delegateSearch: searchProductHomeProtocol?
    var searchTextActive: Bool = false
    
    
    func performSearch(with searchText: String) {
        if searchText.isEmpty {
            searchTextActive = false
        } else {
            searchTextActive = true
        }
        delegateSearch?.searchProdFetch(isActive: searchTextActive, textString: searchText)
    }
    
    func getData(completion:@escaping (ProductIndex) -> ()) {
        guard let url = URL(string: "https://lazaapp.shop/products") else { return }
        
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
