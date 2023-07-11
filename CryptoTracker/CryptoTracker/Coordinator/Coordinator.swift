//
//  Coordinator.swift
//  CryptoTracker
//
//  Created by AziK's  MAC on 07.07.23.
//

import Foundation
import UIKit
protocol Coordinator {
    var navigationController : UINavigationController {get}
    func start()
    func history()
}
class MainCoordinator:Coordinator {
    
    var navigationController = UINavigationController()
    
    func history() {
        navigationController.pushViewController(HistoryVC(), animated: true)
    }
    func start() {
        let vc = HomeVC()
        vc.mainCoordinator = self
        navigationController.pushViewController(vc, animated: false)
        
    }
    
    
}
