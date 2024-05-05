//
//  FavouriteManager.swift
//  StockWave
//
//  Created by rauan on 5/4/24.
//

import Foundation
import Moya

final class FavouriteManager {
    static let shared = FavouriteManager()
    private let provider = MoyaProvider<FavouriteTarget>(plugins: [NetworkLoggerPlugin()])

    func getSingleFovourite(favStock: String, completion: @escaping ([SingleCommodityResponse]) -> () ) {
        provider.request(.getSingleFavourite(favStock: favStock)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode([SingleCommodityResponse].self, from: response.data)
                    DispatchQueue.main.async {
                        completion(decodedData)
                    }
                }
                catch {
                    print("getSingleCommodityError: \(error)")
                }
                
            case .failure(let error):
                print("SingleCommodityError: \(error)")
            }
        }
    }
    
}
