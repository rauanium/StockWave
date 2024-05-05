//
//  FavouriteTarget.swift
//  StockWave
//
//  Created by rauan on 5/4/24.
//

import Foundation
import Moya

enum FavouriteTarget {
    case getSingleFavourite(favStock: String)
}

extension FavouriteTarget: BaseTargetType {
    var baseURL: URL {
        return URL(string: GlobalData.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getSingleFavourite(let favStock):
            return "quote/\(favStock)"
        }
    }
    
    var task: Moya.Task {
        return .requestParameters(parameters: ["apikey": "773U9cq7jzwBvw9gPs6GN4i42h3YyOCh"],
                                  encoding: URLEncoding.default)
    }
}


