//
//  Date Time.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 18/08/23.
//

import Foundation
class DateTimeUtils {
    static let shared = DateTimeUtils()
    
    private let formatter = DateFormatter()
    
    func formatReview(date: String) -> String {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let formattedDate = formatter.date(from: date) {
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: formattedDate)
        }
        return date
    }
}
