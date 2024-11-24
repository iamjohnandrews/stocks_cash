//
//  networking.swift
//  stock_cash
//
//  Created by John Andrews on 11/22/24.
//

import Foundation

protocol StockServiceProtocol {
    func fetchStocks(from url: URL, completion: @escaping (Result<[Stock], Error>) -> Void)
}

class StockService: StockServiceProtocol {
    private let cacheKey = "cachedStocks"

    func fetchStocks(from url: URL, completion: @escaping (Result<[Stock], Error>) -> Void) {
        NetworkManager().request(url) { [weak self] (result: Result<[Stock], Error>) in
            switch result {
            case .success(let stocks):
                self?.cacheStocks(stocks)
                completion(.success(stocks))
            case .failure(let error):
                if let cachedStocks = self?.getCachedStocks() {
                    completion(.success(cachedStocks))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }

    private func cacheStocks(_ stocks: [Stock]) {
        if let data = try? JSONEncoder().encode(stocks) {
            UserDefaults.standard.set(data, forKey: cacheKey)
        }
    }

    private func getCachedStocks() -> [Stock]? {
        if let data = UserDefaults.standard.data(forKey: cacheKey) {
            return try? JSONDecoder().decode([Stock].self, from: data)
        }
        return nil
    }
}


class NetworkManager {
    func request<T: Decodable>(_ url: URL, completion: @escaping (Result<T, Error>) -> Void) {
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
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
