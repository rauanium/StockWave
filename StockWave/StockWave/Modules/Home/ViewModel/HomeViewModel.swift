//
//  HomeViewModel.swift
//  StockWave
//
//  Created by rauan on 4/23/24.
//

import Foundation

struct HomeViewModel {
    
    let dispatchGroup = DispatchGroup()
    
    var singleCommoditiesDetails:[HomeStocksDataModel] = []
    func getMostActiveStocks(completion: @escaping ([ActiveGainersLosersResponse]) -> ()) {
        TrendingStocks.shared.getMostActive { result in
            completion(result.reversed())
        }
    }
    
    func getMostGainersStocks(completion: @escaping ([ActiveGainersLosersResponse]) -> ()) {
        TrendingStocks.shared.getMostGainers { result in
            
            completion(result.reversed())
        }
    }
    
    func getMostLosersStocks(completion: @escaping ([ActiveGainersLosersResponse]) -> ()) {
        TrendingStocks.shared.getMostLosers { result in
            completion(result.reversed())
        }
    }

    func getCommodities(completion: @escaping ([SingleCommodityResponse]) -> Void) {
        var commoditiesList: [String] = ["ZOUSX", "KEUSX"]
        var details: [SingleCommodityResponse] = []

//        dispatchGroup.enter()
//        Commodities.shared.getAvailableCommodities { availableCommodities in
//            
//            commoditiesList = availableCommodities
//            dispatchGroup.leave()
//            
//        }
        
//        dispatchGroup.notify(queue: .main) {
            for i in 0..<commoditiesList.count {
                Commodities.shared.getSingleCommodity(commodity: commoditiesList[i]) { commodityDetails in
                    details.append(.init(
                        symbol: commodityDetails.first?.symbol,
                        name: commodityDetails.first?.name,
                        price: commodityDetails.first?.price,
                        changesPercentage: commodityDetails.first?.changesPercentage,
                        change: commodityDetails.first?.change
                        
                    ))
                    print("commodityDetails: \(details)")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {
                        if commoditiesList.last == commoditiesList[i] {
                            completion(details)
                        }
                    }
                    
                    
                }
            }
//        }
        
        
        
        
        
        
        
        
    }

        
        
}
    
    
    
    

