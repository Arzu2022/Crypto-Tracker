//
//  HomeModel.swift
//  CryptoTracker
//
//  Created by AziK's  MAC on 05.07.23.
//

import Foundation
struct CoinsDTO:Codable {
        let id, symbol, name: String
        let image: String?
        let current_price: Double?
        let market_cap, market_cap_rank: Int?
        let fully_diluted_valuation: Int?
        let total_volume, high_24H, low_24H, priceChange_24H: Double?
        let price_change_24h,market_cap_change_percentage_24h, market_cap_change_24h, price_change_percentage_24h, circulating_supply: Double?
        let total_supply, max_supply: Double?
        let ath, ath_change_percentage: Double?
        let ath_date: String?
        let atl, atl_change_percentage: Double?
        let atl_date: String?
        let roi: Roi?
        let lastUpdated: String?
}
struct Roi:Codable {
        let times: Double
        let currency: String
        let percentage: Double
}
