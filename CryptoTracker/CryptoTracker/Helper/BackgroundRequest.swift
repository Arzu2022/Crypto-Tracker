//
//  BackgroundRequest.swift
//  CryptoTracker
//
//  Created by AziK's  MAC on 08.07.23.
//

import Foundation
import UIKit

protocol BackgroundTimerDelegate: AnyObject {
    func backgroundTimerTaskExecuted(task: UIBackgroundTaskIdentifier, willRepeat: Bool)
}

final class BackgroundTimer {
    var delegate: BackgroundTimerDelegate
    init(delegate: BackgroundTimerDelegate?) {
        self.delegate = delegate!
    }
    
    
    func executeAfterDelay(delay: TimeInterval, repeating: Bool, completion: @escaping(()->Void)) -> UIBackgroundTaskIdentifier {
        var backgroundTaskId = UIBackgroundTaskIdentifier.invalid
        backgroundTaskId = UIApplication.shared.beginBackgroundTask {
            UIApplication.shared.endBackgroundTask(backgroundTaskId)
        }
        wait(delay: delay,
             repeating: repeating,
             backgroundTaskId: backgroundTaskId,
             completion: completion
        )
        return backgroundTaskId
    }
    
    private func wait(delay: TimeInterval, repeating: Bool, backgroundTaskId: UIBackgroundTaskIdentifier, completion: @escaping(()->Void)) {
        print("BackgroundTimer: Starting \(delay) seconds countdown")
        let startTime = Date()

        DispatchQueue.global(qos: .background).async {
            while Date().timeIntervalSince(startTime) < delay {
                Thread.sleep(forTimeInterval: 0.1)
            }
            
            DispatchQueue.main.async {
                completion()
                self.delegate.backgroundTimerTaskExecuted(task: backgroundTaskId, willRepeat: repeating)
                
                if repeating {
                        self.wait(delay: delay,
                             repeating: repeating,
                             backgroundTaskId: backgroundTaskId,
                             completion: completion
                        )
                } else {
                    UIApplication.shared.endBackgroundTask(backgroundTaskId)
                }
            }
        }
    }
}
