//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by AziK's  MAC 
//

import Foundation
import Promises
class HomeViewModel {
    static let shared = HomeViewModel()
    private let request = CoinsRequest()
    var data:[CoinsDTO] = []
    private init(){}
    func getAllCoins()-> Promise<Bool>{
        let promise = Promise<Bool>.pending()
        request.getAllcoins(api: .allCoins).then { result in
            switch result {
              case .success(let data):
                self.data =  data.sorted { $0.current_price! > $1.current_price! }
                promise.fulfill(true)
            case .failure(_):
                promise.fulfill(false)
            }
        }
        return promise
    }
}
