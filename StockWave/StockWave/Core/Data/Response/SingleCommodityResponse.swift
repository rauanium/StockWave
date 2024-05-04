//
//  SingleCommodityResponse.swift
//  StockWave
//
//  Created by rauan on 4/26/24.
//

import Foundation

struct SingleCommodityResponse: Decodable {
    let symbol: String?
    let name: String?
    let price: Double?
    let changesPercentage: Double?
    let change: Double?
}

//{
//    "symbol": "ZOUSX",
//    "name": "Oat Futures",
//    "price": 353,
//    "changesPercentage": -0.21201,
//    "change": -0.75,
//    "dayLow": 342.5,
//    "dayHigh": 368.75,
//    "yearHigh": 496.25,
//    "yearLow": 291.5,
//    "marketCap": null,
//    "priceAvg50": 362.145,
//    "priceAvg200": 391.455,
//    "exchange": "COMMODITY",
//    "volume": 440,
//    "avgVolume": 377,
//    "open": 354,
//    "previousClose": 353.75,
//    "eps": null,
//    "pe": null,
//    "earningsAnnouncement": null,
//    "sharesOutstanding": null,
//    "timestamp": 1714069197
//  }
//]
