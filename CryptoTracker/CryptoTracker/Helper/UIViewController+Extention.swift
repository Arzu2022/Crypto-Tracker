//
//  UIViewController+Extention.swift
//  CryptoTracker
//
//  Created by AziK's  MAC on 09.07.23.
//

import Foundation
import UIKit
extension UIViewController {
    func showToast(message : String, seconds: Double){
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.view.backgroundColor = .black
            alert.view.alpha = 0.5
            alert.view.layer.cornerRadius = 15
            self.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                alert.dismiss(animated: true)
            }
        }
    func showAlert(row:Int) {
            let alert = UIAlertController(title: "", message: "Do you want delete this one?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                let dataDecoded = UserDefaults.standard.object(forKey: "history")
                let decoder = JSONDecoder()
                var arr = try! decoder.decode([HistoryModel].self, from: dataDecoded as! Data)
                arr.remove(at: row)
                do {
                    let encoder = JSONEncoder()
                    let encodedData = try encoder.encode(arr)
                    UserDefaults.standard.set(encodedData, forKey: "history")
                } catch {
                    print("Error encoding struct: \(error)")
                }
            })
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
            })
            alert.addAction(ok)
            alert.addAction(cancel)
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
            })
        }
}
