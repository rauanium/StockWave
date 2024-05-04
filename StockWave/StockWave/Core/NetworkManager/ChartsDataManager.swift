//
//  ChartsDataManager.swift
//  StockWave
//
//  Created by rauan on 5/1/24.
//

import Foundation
import Moya

final class ChartsDataManager {
    static let shared = ChartsDataManager()
    private let provider = MoyaProvider<ChartDataTarget>(plugins: [NetworkLoggerPlugin()])
    
    //MARK: - Getting Weekly charts
    func getWeeklyCharts(ticker: String, completion: @escaping ([Historical]) -> () ) {
        provider.request(.getWeek(ticker: ticker)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(WeeklyChartsResponse.self, from: response.data)
                    DispatchQueue.main.async {
//                        print("weekly \(decodedData)")
                        completion(decodedData.historical)
                    }
                }
                catch {
                    print("ChartsDataManagerError: \(error)")
                }
                
            case .failure(let error):
                print("ChartsDataManagerError: \(error)")
            }
        }
    }
    
    //MARK: - Getting daily charts
    func getDailyCharts(ticker: String, from: String, to: String, completion: @escaping ([Historical]) -> () ) {
        provider.request(.getDaily(ticker: ticker, from: from, to: to)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode([Historical].self, from: response.data)
                    DispatchQueue.main.async {
//                        print("daily \(decodedData)")
                        completion(decodedData)
                    }
                }
                catch {
                    print("DailyChartsDataManagerCatch: \(error)")
                }
                
            case .failure(let error):
                print("DailyChartsDataManagerFilureCase: \(error)")
            }
        }
    }
    
}
