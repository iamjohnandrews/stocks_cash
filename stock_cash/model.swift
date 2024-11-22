//
//  model.swift
//  stock_cash
//
//  Created by John Andrews on 11/22/24.
//

struct Stock: Codable {
    let ticker: String
    let name: String
    let currency: String
    let currentPriceCents: Int
    let quantity: Int?
    let currentPriceTimestamp: Int
}

struct Portfolio: Codable {
    let stocks: [Stock]
}
