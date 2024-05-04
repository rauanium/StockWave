//
//  ChartDataTarget.swift
//  StockWave
//
//  Created by rauan on 5/1/24.
//

import Foundation
import Moya

enum ChartDataTarget {
    case getWeek(ticker: String)
    case getDaily(ticker: String, from: String, to: String)
//    case getGainers
}

extension ChartDataTarget: BaseTargetType {
    var baseURL: URL {
        return URL(string: GlobalData.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getWeek(let ticker):
            return "historical-price-full/\(ticker)"
        case .getDaily(let ticker, _, _):
            return "historical-chart/30min/\(ticker)"
//        case .getLosers:
//            return "stock_market/losers"
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getWeek:
            return .requestParameters(parameters: ["apikey": "773U9cq7jzwBvw9gPs6GN4i42h3YyOCh"],
                                      encoding: URLEncoding.default)
        
        case .getDaily(_, from: let from, to: let to):
            return .requestParameters(parameters: ["apikey": "773U9cq7jzwBvw9gPs6GN4i42h3YyOCh",
                                                   "from" : from,
                                                   "to": to
                                                  ],
                                      encoding: URLEncoding.default)
        }
    }
}
