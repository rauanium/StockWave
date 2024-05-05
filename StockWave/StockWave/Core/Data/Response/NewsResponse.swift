//
//  NewsResponse.swift
//  StockWave
//
//  Created by rauan on 5/5/24.
//

import Foundation

struct NewsResponse: Decodable {
    let feed: [Feed]
}

struct Feed: Decodable {
    let title: String
    let url: String
    let summary: String
}
