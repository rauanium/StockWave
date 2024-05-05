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
        var active: [ActiveGainersLosersResponse] = []
        TrendingStocks.shared.getMostActive { result in
            active = result
            active.sort {
                $0.changesPercentage ?? 0.0 < $1.changesPercentage ?? 0.0
            }
            completion(active.reversed())
        }
    }
    
    func getMostGainersStocks(completion: @escaping ([ActiveGainersLosersResponse]) -> ()) {
        var gainers: [ActiveGainersLosersResponse] = []
        TrendingStocks.shared.getMostGainers { result in
            
            gainers = result
            gainers.sort {
                $0.changesPercentage ?? 0.0 < $1.changesPercentage ?? 0.0
            }
            completion(gainers.reversed())
        }
    }
    
    func getMostLosersStocks(completion: @escaping ([ActiveGainersLosersResponse]) -> ()) {
        var losers: [ActiveGainersLosersResponse] = []
        TrendingStocks.shared.getMostLosers { result in
            losers = result
            losers.sort {
                $0.changesPercentage ?? 0.0 < $1.changesPercentage ?? 0.0
            }
            completion(losers)
        }
    }

    func getCommodities(completion: @escaping ([SingleCommodityResponse]) -> Void) {
        var commoditiesList: [AvailableCommoditiesResponse] = []
        var details: [SingleCommodityResponse] = []

        dispatchGroup.enter()
        Commodities.shared.getAvailableCommodities { availableCommodities in
            
            commoditiesList = availableCommodities
            dispatchGroup.leave()
            
        }
        
        dispatchGroup.notify(queue: .main) {
            for i in 0..<commoditiesList.count {
                Commodities.shared.getSingleCommodity(commodity: commoditiesList[i].symbol) { commodityDetails in
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
        }
         
        
    }
    
    func getFavourite(favStock: String, completion: @escaping ([HomeStocksDataModel]) -> Void ) {
        var favList: [HomeStocksDataModel] = []
        FavouriteManager.shared.getSingleFovourite(favStock: favStock) { favDetails in
            print("favDEtails: \(favDetails)")
            
            favList.append(.init(
                symbol: favDetails.first?.symbol,
                name: favDetails.first?.name,
                price: favDetails.first?.price,
                changesPercentage: favDetails.first?.changesPercentage,
                change: favDetails.first?.change))
            
            completion(favList)
        }
    }

        
        
}
    
    
    
    

