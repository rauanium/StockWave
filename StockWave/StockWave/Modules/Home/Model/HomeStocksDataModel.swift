//
//  HomeStocksDataModel.swift
//  StockWave
//
//  Created by rauan on 4/24/24.
//

import Foundation

struct HomeStocksDataModel {
    var identifier = UUID()
    
    private enum CodingKeys : String, CodingKey { case id, image, title, arist }
    
    let symbol: String?
    let name: String?
    let price: Double?
    let changesPercentage: Double?
    let change: Double?
    
}

extension HomeStocksDataModel : Hashable {
    static func == (lhs: HomeStocksDataModel, rhs: HomeStocksDataModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
