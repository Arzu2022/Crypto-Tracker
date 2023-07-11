//
//  API.swift
//  CryptoTracker
//
//  Created by AziK's  MAC 
//

enum CoinsAPI:String {
    case allCoins = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd"
    case getPrize = "https://api.coingecko.com/api/v3/simple/price?ids=1337&vs_currencies=usd"
}
