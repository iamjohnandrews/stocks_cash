//
//  stock_cashTests.swift
//  stock_cashTests
//
//  Created by John Andrews on 11/22/24.
//

import Testing
import XCTest
@testable import stock_cash


class StockServiceTests: XCTestCase {
    func testFetchStocks() {
        let service = StockService()
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
}

class StockViewModelTests: XCTestCase {
    func testViewModelHandlesEmptyState() {
        let viewModel = StockViewModel()
        viewModel.state = .empty
        XCTAssertEqual(viewModel.state, .empty, "ViewModel should correctly represent the empty state")
    }
    
}

