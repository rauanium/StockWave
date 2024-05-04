//
//  WeeklyChartsResponse.swift
//  StockWave
//
//  Created by rauan on 5/1/24.
//

import Foundation

struct WeeklyChartsResponse: Decodable {
    let symbol: String
    let historical: [Historical]
}

// MARK: - Historical
struct Historical: Decodable {
    let date: String?
    let open: Double?
    
    
}
