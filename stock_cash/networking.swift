//
//  networking.swift
//  stock_cash
//
//  Created by John Andrews on 11/22/24.
//

import Foundation

class StockService {
    func fetchStocks(from url: URL, completion: @escaping (Result<[Stock], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }
            do {
                let portfolio = try JSONDecoder().decode(Portfolio.self, from: data)
                completion(.success(portfolio.stocks))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

