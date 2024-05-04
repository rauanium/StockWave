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
    
    let id: String
    let companyImage: URL?
    let companyTicker: String
    let companyName: String
    let companyPrice: Double
    let companyChange: Double?
    let companyChangePercentage: Double
    
}

extension HomeStocksDataModel : Hashable {
    static func == (lhs: HomeStocksDataModel, rhs: HomeStocksDataModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
