//
//  Commodities.swift
//  StockWave
//
//  Created by rauan on 4/26/24.
//

import Foundation
import Moya

final class Commodities {
    static let shared = Commodities()
    private let provider = MoyaProvider<CommoditiesTarget>(plugins: [NetworkLoggerPlugin()])
    
    //MARK: - Getting AvailAble Commodities
    func getAvailableCommodities(completion: @escaping ([AvailableCommoditiesResponse]) -> () ) {
        provider.request(.getAvailableCommodities) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode([AvailableCommoditiesResponse].self, from: response.data)
                    DispatchQueue.main.async {
                        completion(decodedData)
                    }
                }
                catch {
                    print("AvailableCommoditiesError: \(error)")
                }
                
            case .failure(let error):
                print("AvailableCommoditiesError: \(error)")
            }
        }
    }
    
    func getSingleCommodity(commodity: String, completion: @escaping ([SingleCommodityResponse]) -> () ) {
        provider.request(.getSingleCommodity(commodity: commodity)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode([SingleCommodityResponse].self, from: response.data)
                    DispatchQueue.main.async {
                        completion(decodedData)
                    }
                }
                catch {
                    print("SingleCommoditiesError: \(error)")
                }
                
            case .failure(let error):
                print("SingleCommoditiesError: \(error)")
            }
        }
    }
    
    
    
    
    
}
