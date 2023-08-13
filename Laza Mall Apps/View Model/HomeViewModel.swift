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
}
