//
//  SearchTargetType.swift
//  StockWave
//
//  Created by Mariya Aliyeva on 04.05.2024.
//

import Foundation
import Moya

enum SearchTargetType {
	case getSymbol(symbol: String)
}

extension SearchTargetType: BaseTargetType {
	
	var baseURL: URL {
			return URL(string: GlobalData.baseURL)!
	}
	
	var path: String {
			switch self {
			case .getSymbol:
				return "search"
			}
	}
	
	var task: Moya.Task {
		switch self {
			
		case .getSymbol(let symbol):
			return .requestParameters(parameters: [
				"apikey": "773U9cq7jzwBvw9gPs6GN4i42h3YyOCh",
				"query": symbol
			], encoding: URLEncoding.default
			)
		}
	}
}
