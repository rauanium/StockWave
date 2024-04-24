//
//  HomeViewModel.swift
//  StockWave
//
//  Created by rauan on 4/23/24.
//

import Foundation

struct HomeViewModel {
    func getTrending(completion: @escaping ([ActiveGainersLosersResponse]) -> ()) {
        TrendingStocks.shared.getMostActive { items in
            completion(items)
        }
        
    }
}
