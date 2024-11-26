//
//  stock_cashTests.swift
//  stock_cashTests
//
//  Created by John Andrews on 11/22/24.
//

import XCTest
@testable import stock_cash

class StockServiceTests: XCTestCase {
    func testFetchStocksSuccess() {
        let mockNetworkManager = MockNetworkManager()
        let service = StockService(networkManager: mockNetworkManager)
        let url = URL(string: "https://storage.googleapis.com/cash-homework/cash-stocks-api/portfolio.json")!
        let expectation = self.expectation(description: "Fetching stocks succeeds")
        
        service.fetchStocks(from: url) { result in
            switch result {
            case .success(let stocks):
                XCTAssertFalse(stocks.isEmpty, "Stocks list should not be empty")
            case .failure(let error):
                XCTFail("Fetching stocks failed with error: \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    func testFetchStocksFailure() {
        let mockNetworkManager = MockNetworkManager()
        let service = StockService(networkManager: mockNetworkManager)
        let url = URL(string: "https://storage.googleapis.com/cash-homework/cash-stocks-api/portfolio_malformed.json")!
        let expectation = self.expectation(description: "Fetching stocks failed")
        
        service.fetchStocks(from: url) { result in
            switch result {
            case .success(let stocks):
                XCTFail("Stocks should have errored out but received \(stocks)")
            case .failure(let error):
                XCTAssertNotNil(error, "Stocks should have errored out")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}

class MockNetworkManager: NetworkManagerProtocol {
    func request<T: Decodable>(_ url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let bundle = Bundle(for: type(of: self))
            let file = try XCTUnwrap(url.lastPathComponent.replacingOccurrences(of: ".json", with: ""))
            let path = try XCTUnwrap(bundle.path(forResource: file, ofType: "json"))
            let data = try XCTUnwrap(NSData(contentsOfFile: path) as? Data)
            let response = try JSONDecoder().decode(T.self, from: data)
            completion(.success(response))
        } catch {
            completion(.failure(CustomError.failedToGetMock))
        }
    }
}

enum CustomError: Error {
    case failedToGetMock
}
