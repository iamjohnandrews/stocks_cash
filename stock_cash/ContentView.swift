//
//  ContentView.swift
//  stock_cash
//
//  Created by John Andrews on 11/22/24.
//

import SwiftUI

struct StockListView: View {
    @StateObject private var viewModel = StockViewModel()

    var body: some View {
        VStack {
            TextField("search stocks", text: $viewModel.filterQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.top)
    
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView("Loading stocks...")
                case .loaded:
                    List(viewModel.filteredStocks) { stock in
                        StockRowView(stock: stock)
                    }
                case .empty:
                    Text("No stocks available.")
                        .font(.headline)
                        .foregroundColor(.gray)
                case .noresults:
                    Text("No stocks in search results.")
                        .font(.headline)
                        .foregroundColor(.gray)
                case .error(let message):
                    VStack {
                        Text("Error: \(message)")
                            .foregroundColor(.red)
                        Button("Retry") {
                            viewModel.fetchStocks()
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchStocks()
        }
    }
}

struct StockRowView: View {
    let stock: Stock

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stock.name).font(.headline)
                Text(stock.ticker).font(.subheadline).foregroundColor(.gray)
            }
            Spacer()
            Text("\(stock.currency) \(Double(stock.currentPriceCents) / 100, specifier: "%.2f")")
                .bold()
        }
    }
}


#Preview {
    StockListView()
}
