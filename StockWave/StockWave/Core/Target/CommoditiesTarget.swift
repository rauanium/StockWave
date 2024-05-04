//
//  CommoditiesTarget.swift
//  StockWave
//
//  Created by rauan on 4/26/24.
//

import Foundation
import Moya

enum CommoditiesTarget {
    case getAvailableCommodities
    case getSingleCommodity(commodity: String)
}

extension CommoditiesTarget: BaseTargetType {
    var baseURL: URL {
        return URL(string: GlobalData.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getAvailableCommodities:
            return "symbol/available-commodities"
        case .getSingleCommodity(let commodity):
            return "quote/\(commodity)"
        }
    }
    
    var task: Moya.Task {
        return .requestParameters(parameters: ["apikey": "ysPec5JNkAoh6jdNynGU92zFtb1G5hm1"],
                                  encoding: URLEncoding.default)
    }
}


