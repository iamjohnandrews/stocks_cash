//
//  viewModel.swift
//  stock_cash
//
//  Created by John Andrews on 11/22/24.
//

import Foundation

class StockViewModel: ObservableObject {
    @Published var stocks: [Stock] = []
    @Published var state: ViewState = .loading

    enum ViewState {
        case loading
        case loaded
        case empty
        case error(String)
    }

    private let service = StockService()

    func fetchStocks() {
        state = .loading
        let url = URL(string: "https://storage.googleapis.com/cash-homework/cash-stocks-api/portfolio.json")!

        service.fetchStocks(from: url) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let stocks):
                    if stocks.isEmpty {
                        self?.state = .empty
                    } else {
                        self?.stocks = stocks
                        self?.state = .loaded
                    }
                case .failure(let error):
                    self?.state = .error(error.localizedDescription)
                }
            }
        }
    }
}
