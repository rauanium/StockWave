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
    private let provider = MoyaProvider<ActiveGainersLosersTarget>(plugins: [NetworkLoggerPlugin()])
    
    //MARK: - Getting active
    func getMostActive(completion: @escaping ([ActiveGainersLosersResponse]) -> () ) {
        provider.request(.getActive) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode([ActiveGainersLosersResponse].self, from: response.data)
                    DispatchQueue.main.async {
                        completion(decodedData)
                    }
                }
                catch {
                    print("ActivesError: \(error)")
                }
                
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
    
    //MARK: - Getting gainers
    func getMostGainers(completion: @escaping ([ActiveGainersLosersResponse]) -> () ) {
        provider.request(.getGainers) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode([ActiveGainersLosersResponse].self, from: response.data)
                    DispatchQueue.main.async {
                        
                        completion(decodedData)
                    }
                }
                catch {
                    print("GainersError: \(error)")
                }
                
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
    
    //MARK: - Getting losers
    func getMostLosers(completion: @escaping ([ActiveGainersLosersResponse]) -> () ) {
        provider.request(.getLosers) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode([ActiveGainersLosersResponse].self, from: response.data)
                    DispatchQueue.main.async {
                        completion(decodedData)
                    }
                }
                catch {
                    print("LosersError: \(error)")
                }
                
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
}

