//
//  networking.swift
//  stock_cash
//
//  Created by John Andrews on 11/22/24.
//

import Foundation

class StockService {
    class StockService {
        private let networkManager = NetworkManager()

        func fetchStocks(from url: URL, completion: @escaping (Result<[Stock], Error>) -> Void) {
            networkManager.request(url, completion: completion)
        }
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
