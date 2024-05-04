//
//  ActiveGainersLosersTarget.swift
//  StockWave
//
//  Created by rauan on 4/23/24.
//

import Foundation
import Moya

enum ActiveGainersLosersTarget {
    case getActive
    case getLosers
    case getGainers
}

extension ActiveGainersLosersTarget: BaseTargetType {
    var baseURL: URL {
        return URL(string: GlobalData.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getActive:
            return "stock_market/actives"
        case .getGainers:
            return "stock_market/gainers"
        case .getLosers:
            return "stock_market/losers"
        }
    }
    
    var task: Moya.Task {
        return .requestParameters(parameters: ["apikey": "ysPec5JNkAoh6jdNynGU92zFtb1G5hm1"],
                                  encoding: URLEncoding.default)
    }
}
//ysPec5JNkAoh6jdNynGU92zFtb1G5hm1 - aspark
//LdkDAgkHEr7Vl7fWyFPvi0U3Dkx9AFVS - r.zhaukenov
//n2g6J4FFFpYhrivKY7DjuJh8RDrhLN2a - rauan


