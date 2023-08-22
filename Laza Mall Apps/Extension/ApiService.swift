//
//  ApiService.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 17/08/23.
//
//Dua metode statis yang digunakan untuk menghasilkan data yang akan digunakan sebagai body dalam permintaan HTTP
import Foundation
class ApiService {
    static func getHttpBodyForm(param: [String:Any]) -> Data? {
        var body = [String]()
        param.forEach { (key, value) in
            body.append("\(key)=\(value)")
        }
        let bodyString = body.joined(separator: "&")
        return bodyString.data(using: .utf8)
    }
    
    static func getHttpBodyRaw(param: [String:Any]) -> Data?{
        let jsonData = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        return jsonData
    }
    
    static func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}
