//
//  ApiService.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 17/08/23.
//
//Dua metode statis yang digunakan untuk menghasilkan data yang akan digunakan sebagai body dalam permintaan HTTP
import Foundation
class ApiService {
    
    // Metode untuk menghasilkan body HTTP dengan format form URL-encoded
    static func getHttpBodyForm(param: [String:Any]) -> Data? {
        var body = [String]()
        param.forEach { (key, value) in
            body.append("\(key)=\(value)")
        }
        let bodyString = body.joined(separator: "&")
        return bodyString.data(using: .utf8)
    }
    
    // Metode untuk menghasilkan body HTTP dengan format JSON
    static func getHttpBodyRaw(param: [String:Any]) -> Data?{
        let jsonData = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        return jsonData
    }
    
    // Metode untuk menghasilkan batas (boundary) untuk request multipart/form-data
    static func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    // Metode untuk menghasilkan body HTTP dengan format multipart/form-data
    static func getApiByFormData(withParameters params: [String: String]?, media: Media?, boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        if let media = media {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(media.key)\"; filename=\"\(media.filename)\"\(lineBreak)")
            body.append("Content-Type: \(media.mimeType + lineBreak + lineBreak)")
            body.append(media.data)
            body.append(lineBreak)
        }
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    
    // Metode untuk menghasilkan batas (boundary) untuk request multipart/form-data
    static func getBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}

// Extension untuk Data yang memungkinkan penggabungan string menjadi data
extension Data {
    mutating func append(_ string: String) {
        if let data =  string.data(using: .utf8) {
            append(data)
        }
    }
}

