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
    @Published var filterQuery: String = ""
    var filteredStocks: [Stock] {
        if filterQuery.isEmpty {
            return stocks
        } else {
            let a = stocks.filter { stock in
                stock.name.lowercased().contains(filterQuery.lowercased()) ||
                stock.ticker.lowercased().contains(filterQuery.lowercased())
            }
            if a.isEmpty {
                state = .noresults
            } else {
                state = .loading
            }
            return a
        }
    }

    enum ViewState: Equatable {
        case loading
        case loaded
        case empty
        case error(String)
        case noresults
    }

    private let service: StockService
    
    init(service: StockService = StockService()) {
        self.service = service
    }

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
