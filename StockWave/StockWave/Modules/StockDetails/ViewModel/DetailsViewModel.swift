//
//  DetailsViewModel.swift
//  StockWave
//
//  Created by rauan on 5/1/24.
//

import Foundation

struct DetailsViewModel {
    
    func getWeeklyCharts(ticker: String, completion: @escaping ([Historical]) -> Void) {
        ChartsDataManager.shared.getWeeklyCharts(ticker: ticker) { chartsData in
            completion(chartsData.reversed())
        }
    }
    
    func getDailyCharts(ticker: String, from: String, to: String, completion: @escaping ([Historical]) -> Void){
        ChartsDataManager.shared.getDailyCharts(ticker: ticker, from: from, to: to) { dailyChartsData in
//            print("dailyChartsData: \(dailyChartsData)")
            completion(dailyChartsData.reversed())
        }
    }
    
    func getCompanyInformation(ticker: String, completion: @escaping (CompanyInformationResponse) -> Void){
        CompanyInformaitonManager.shared.getCompanyInformaiton(ticker: ticker) { companyInformation in
            completion(companyInformation.first ?? .init(volAvg: nil, mktCap: nil, range: nil, industry: nil, description: nil, ceo: nil, sector: nil, country: nil, city: nil, ipoDate: nil, fullTimeEmployees: nil, companyName: nil))
        }
    }
    
    func getCompanyFinancialInformation(ticker: String,
                                        completion: @escaping ([CompanyFinancialInformationResponse]) -> Void) {
        CompanyInformaitonManager.shared.getCompanyFinancialInformaiton(ticker: ticker) { financialInformation in
            
            completion(financialInformation.reversed())
        }
    }
    
    func getNews(ticker: String, completion: @escaping ([Feed]) -> Void) {
        NewsManager.shared.getNews(ticker: ticker) { feed in
            completion(feed)
        }
    }
    
        
}
