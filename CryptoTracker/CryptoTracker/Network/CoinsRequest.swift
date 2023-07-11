//
//  CoinsRequest.swift
//  CryptoTracker
//
//  Created by AziK's  MAC 
//

import Foundation
import Alamofire
import Promises
protocol CoinsRequestProtocol {
    func getAllcoins(api:CoinsAPI) -> Promise<Result<[CoinsDTO],Error>>
}
class CoinsRequest:CoinsRequestProtocol {
    func getAllcoins(api: CoinsAPI) -> Promises.Promise<Result<[CoinsDTO], Error>> {
        let promise = Promise<Result<[CoinsDTO],Error>>.pending()
        AF.request(URL(string: api.rawValue)!, method: .get).responseDecodable(of: [CoinsDTO].self) { response in
            if let err = response.error {
                promise.fulfill(.failure(err))
            } else {
                if let data = response.value {
                    promise.fulfill(.success(data))
                }
                else {
                    promise.fulfill(.failure(Error.self as! Error))
                }
            }
        }
        return promise
    }
}
