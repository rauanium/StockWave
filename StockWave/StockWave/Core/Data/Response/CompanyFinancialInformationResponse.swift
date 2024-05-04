//
//  CompanyFinancialInformationResponse.swift
//  StockWave
//
//  Created by rauan on 5/4/24.
//

import Foundation

struct CompanyFinancialInformationResponse: Decodable {
    let calendarYear: String?
    let revenue: Double?
    let netIncome: Double?
    let eps: Double?
    let ebitda: Double?
    let weightedAverageShsOut: Double?
    let researchAndDevelopmentExpenses: Double?
    
}
