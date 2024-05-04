//
//  ActiveGainersLosersResponse.swift
//  StockWave
//
//  Created by rauan on 4/23/24.
//

import Foundation

struct ActiveGainersLosersResponse: Decodable {
    let symbol: String?
    let name: String?
    let change: Double?
    let price: Double?
    let changesPercentage: Double?
}
