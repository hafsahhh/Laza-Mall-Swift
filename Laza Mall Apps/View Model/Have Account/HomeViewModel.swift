//
//  HomeViewModel.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 11/08/23.
//

import Foundation

class HomeViewModel {
    
    // Properti delegate yang digunakan untuk pencarian produk
    weak var delegateSearch: searchProductHomeProtocol?
    // Menyimpan status apakah teks pencarian aktif atau tidak
    var searchTextActive: Bool = false
    
    // Fungsi untuk melakukan pencarian produk dengan teks pencarian tertentu
    func performSearch(with searchText: String) {
        if searchText.isEmpty {
            searchTextActive = false
        } else {
            searchTextActive = true
        }
        // Memanggil metode delegate untuk mengirim status pencarian dan teks pencarian ke delegate
        delegateSearch?.searchProdFetch(isActive: searchTextActive, textString: searchText)
    }
    
    // Fungsi untuk mendapatkan data produk
    func getData(completion: @escaping (ProductIndex) -> ()) {
        // Membuat URL untuk mengambil semua produk
        guard let url = URL(string: Endpoints.Gets.productAll.url) else { return }
        
        // Melakukan permintaan HTTP untuk mendapatkan data produk
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                // Mendekode data JSON menjadi model ProductIndex
                let productList = try JSONDecoder().decode(ProductIndex.self, from: data)
                DispatchQueue.main.async {
                    completion(productList)
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
    
    // Fungsi untuk mendapatkan data semua merek produk
    func getBrandAllData(completion: @escaping (brandAllIndex) -> ()) {
        
        // Membuat URL untuk mengambil semua merek produk
        guard let url = URL(string: Endpoints.Gets.brandAll.url) else { return }
        
        // Melakukan permintaan HTTP untuk mendapatkan data merek produk
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                // Mendekode data JSON menjadi model brandAllIndex
                let catList = try JSONDecoder().decode(brandAllIndex.self, from: data)
                DispatchQueue.main.async {
                    completion(catList)
                }
            } catch {
                print("Error decoding data category: \(error)")
            }
        }.resume()
    }
}

