//
//  SearchManager.swift
//  StockWave
//
//  Created by Mariya Aliyeva on 04.05.2024.
//

import Foundation
import Moya

final class SearchManager {
	static let shared = SearchManager()
	
	private let provider = MoyaProvider<SearchTargetType>(plugins: [NetworkLoggerPlugin()])
	
	func getSymbol(symbol: String, completion: @escaping ([SearchResponseElement]) -> Void) {
		
		provider.request(.getSymbol(symbol: symbol)) { result in
			switch result {
			case .success(let response):
				do {
					let decodedData = try JSONDecoder().decode(SearchResponse.self, from: response.data)
					DispatchQueue.main.async {
						completion(decodedData)
					}
				}
				catch {
					print(error)
				}
			case .failure(let error):
				print("error: \(error)")
			}
		}
	}
}
