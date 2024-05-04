//
//  CompanyInformationTarget.swift
//  StockWave
//
//  Created by rauan on 5/4/24.
//

import Foundation
import Moya

enum CompanyInformationTarget {
    case getCompanyInformation(ticker: String)
    case getFinancialInformation(ticker: String)
}

extension CompanyInformationTarget: BaseTargetType {
    var baseURL: URL {
        return URL(string: GlobalData.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getCompanyInformation(let ticker):
            return "/profile/\(ticker)"
        case .getFinancialInformation(ticker: let ticker):
            return "income-statement/\(ticker)"
        }
    }
    
    var task: Moya.Task {
        switch self {
            
        case .getCompanyInformation(_):
            return .requestParameters(parameters: ["apikey": "LdkDAgkHEr7Vl7fWyFPvi0U3Dkx9AFVS"],
                                      encoding: URLEncoding.default)
        case .getFinancialInformation(_):
            return .requestParameters(parameters: ["apikey": "LdkDAgkHEr7Vl7fWyFPvi0U3Dkx9AFVS",
                                                   "period": "annual"],
                                                   encoding: URLEncoding.default)
        }
        
    }
}
