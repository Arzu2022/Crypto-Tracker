//
//  HistoryViewModel.swift
//  CryptoTracker
//
//  Created by AziK's  MAC 
//

import Foundation
import Promises

class HistoryViewModel {
    static let shared = HistoryViewModel()
    private init(){}
    var data:[HistoryModel] = []
    
    func fetchData()->Promise<Bool>{
        let promise = Promise<Bool>.pending()
        if let dataDecoded = UserDefaults.standard.object(forKey: "history") {
            let decoder = JSONDecoder()
            self.data = try! decoder.decode([HistoryModel].self, from: dataDecoded as! Data)
            promise.fulfill(true)
        } else {
            promise.fulfill(false)
        }
        return promise
    }
}
