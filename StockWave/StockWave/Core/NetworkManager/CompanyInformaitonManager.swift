//
//  CompanyInformaitonManager.swift
//  StockWave
//
//  Created by rauan on 5/4/24.
//

import Foundation
import Moya

final class CompanyInformaitonManager {
    static let shared = CompanyInformaitonManager()
    private let provider = MoyaProvider<CompanyInformationTarget>(plugins: [NetworkLoggerPlugin()])
    
    //MARK: - Getting Weekly charts
    func getCompanyInformaiton(ticker: String, completion: @escaping ([CompanyInformationResponse]) -> () ) {
        provider.request(.getCompanyInformation(ticker: ticker)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode([CompanyInformationResponse].self, from: response.data)
                    DispatchQueue.main.async {
                        print("information: \(decodedData)")
                        completion(decodedData)
                    }
                }
                catch {
                    print("CompanyInformaitonManagerError: \(error)")
                }
                
            case .failure(let error):
                print("CompanyInformaitonManagerError: \(error)")
            }
        }
    }
    
    func getCompanyFinancialInformaiton(ticker: String, completion: @escaping ([CompanyFinancialInformationResponse]) -> () ) {
        provider.request(.getFinancialInformation(ticker: ticker)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode([CompanyFinancialInformationResponse].self, from: response.data)
                    DispatchQueue.main.async {
                        print("information: \(decodedData)")
                        completion(decodedData)
                    }
                }
                catch {
                    print("CompanyInformaitonManagerError: \(error)")
                }
                
            case .failure(let error):
                print("CompanyInformaitonManagerError: \(error)")
            }
        }
    }
    
    
}
