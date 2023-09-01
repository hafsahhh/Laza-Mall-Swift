//
//  AddReviewVM.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 19/08/23.
//

import Foundation

class AddReviewViewModel{
    
    var apiAlertAddreview : ((String) -> Void)?
    
    
    // MARK: - Func signUpUserAPI
    func addReviewProductApi (comment: String,
                       rating: Double,
                       id: Int,
                       completion: @escaping (Result<Data?, Error>) -> Void)//closure atau blok kode yang dapat dilewatkan ke fungsi sebagai parameter
    {
        
        guard let url = URL(string: Endpoints.Gets.riview(id: id).url) else {return}
        guard let accesToken = KeychainManager.shared.getAccessToken() else { return }
        var request = URLRequest(url: url)
        
        // Membuat permintaan URLRequest dengan menambahkan token ke header
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        request.httpMethod = "POST"
        request.httpBody = ApiService.getHttpBodyRaw(param: [
            "comment": comment,
            "rating": rating
        ])
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                print("Status code Add review: \(httpResponse.statusCode)")
                if statusCode != 201 {
                    // Error
                    print("Response Status Code Add Review Api: \(statusCode)")
                    if let data = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let status = jsonResponse["status"] as? String{
                        DispatchQueue.main.async {
                            self.apiAlertAddreview?(status)
                        }
                    }
                    completion(.failure(ErrorInfo.Error))
                } else {
                    if let data = data,
                       let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let status = jsonResponse["status"] as? String{
                        DispatchQueue.main.async {
                            self.apiAlertAddreview?(status)
                        }
                    }
                    print("Sukses Add Review")
                    // Success
                    completion(.success(data))
                }
            }
        }.resume()
    }
}
