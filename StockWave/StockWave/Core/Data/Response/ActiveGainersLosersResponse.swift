//
//  ActiveGainersLosersResponse.swift
//  StockWave
//
//  Created by rauan on 4/23/24.
//

import Foundation

//struct ActiveGainersLosersResponse: Decodable {
//    let symbol: String
//    let price, beta: Double
//    let volAvg, mktCap: Int
//    let lastDiv: Double
//    let range: String
//    let changes: Double
//    let companyName, currency, cik, isin: String
//    let cusip, exchange, exchangeShortName, industry: String
//    let website: String
//    let description, ceo, sector, country: String
//    let fullTimeEmployees, phone, address, city: String
//    let state, zip: String
//    let dcfDiff, dcf: Double
//    let image: String
//    let ipoDate: String
//    let defaultImage, isEtf, isActivelyTrading, isAdr: Bool
//    let isFund: Bool
//}

struct ActiveGainersLosersResponse: Decodable {
    let symbol: String
    let name: String
    let change: Double
    let price: Double
    let changesPercentage: Double
}
