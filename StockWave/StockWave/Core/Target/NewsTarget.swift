//
//  NewsTarget.swift
//  StockWave
//
//  Created by rauan on 5/5/24.
//

import Foundation
import Moya

enum NewsTarget {
    case getNews(ticker: String)
}

extension NewsTarget: BaseTargetType {
    var baseURL: URL {
        return URL(string: "https://www.alphavantage.co/")!
    }
    
    var path: String {
        switch self {
        case .getNews(_):
            return "query/"
        }
    }
    
    var task: Moya.Task {
        switch self {
            
        case .getNews(ticker: let ticker):
            return .requestParameters(parameters: ["apikey": "9AQD6LTRCKC5C8KT",
                                                   "tickers": ticker,
                                                   "function": "NEWS_SENTIMENT"
                                                  ],
                                      encoding: URLEncoding.default)
        }
        
    }
}





