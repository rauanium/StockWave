//
//  NewsManager.swift
//  StockWave
//
//  Created by rauan on 5/5/24.
//

import Foundation
import Moya

final class NewsManager {
    static let shared = NewsManager()
    private let provider = MoyaProvider<NewsTarget>(plugins: [NetworkLoggerPlugin()])

    func getNews(ticker: String, completion: @escaping ([Feed]) -> () ) {
        provider.request(.getNews(ticker: ticker)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(NewsResponse.self, from: response.data)
                    DispatchQueue.main.async {
                        print("News: \(decodedData.feed)")
                        completion(decodedData.feed)
                    }
                }
                catch {
                    print("NewsCommodityError: \(error)")
                }
                
            case .failure(let error):
                print("NewsCommodityError: \(error)")
            }
        }
    }
    
}
