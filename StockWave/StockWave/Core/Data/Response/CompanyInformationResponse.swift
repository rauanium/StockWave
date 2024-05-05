//
//  CompanyInformationResponse.swift
//  StockWave
//
//  Created by rauan on 5/4/24.
//

import Foundation

struct CompanyInformationResponse: Decodable {
    let volAvg: Int?
    let mktCap: Int?
    let range: String?
    let industry: String?
    let description: String?
    let ceo: String?
    let sector: String?
    let country: String?
    let city: String?
    let ipoDate: String?
    let fullTimeEmployees: String?
    let companyName: String?
}
