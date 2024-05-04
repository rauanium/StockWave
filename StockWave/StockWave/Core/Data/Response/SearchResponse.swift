//
//  SearchResponse.swift
//  StockWave
//
//  Created by Mariya Aliyeva on 04.05.2024.
//

import Foundation

// MARK: - SearchResponseElement
struct SearchResponseElement: Codable {
		let symbol, name: String?
}

typealias SearchResponse = [SearchResponseElement]
