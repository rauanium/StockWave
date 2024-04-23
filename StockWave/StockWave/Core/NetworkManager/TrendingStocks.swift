//
//  TrendingStocks.swift
//  StockWave
//
//  Created by rauan on 4/23/24.
//

import Foundation
import Moya

final class TrendingStocks {
    static let shared = TrendingStocks()
    let jsonString = ""
    private let provider = MoyaProvider<CompanyProfileTarget>(plugins: [NetworkLoggerPlugin()])
    
    func getMostActive(completion: @escaping ([ActiveGainersLosersResponse]) -> () ) {
        provider.request(.getActive) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode([ActiveGainersLosersResponse].self, from: response.data)
                    DispatchQueue.main.async {
                        print("decodedData: \(decodedData)")
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

