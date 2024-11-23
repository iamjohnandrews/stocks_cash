//
//  model.swift
//  stock_cash
//
//  Created by John Andrews on 11/22/24.
//

import Foundation

struct Stock: Codable, Identifiable {
    var id = UUID()
    let ticker: String
    let name: String
    let currency: String
    let currentPriceCents: Int
    let quantity: Int?
    let currentPriceTimestamp: Int
    
    private enum CodingKeys: String, CodingKey {
            case ticker
            case name
            case currency
            case currentPriceCents = "current_price_cents"
            case quantity
            case currentPriceTimestamp = "current_price_timestamp"
        }
}

struct Portfolio: Codable {
    let stocks: [Stock]
}
