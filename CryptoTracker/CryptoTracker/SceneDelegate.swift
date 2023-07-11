//
//  SceneDelegate.swift
//  CryptoTracker
//
//  Created by AziK's  MAC 
//

import UIKit
import Alamofire
import UserNotifications
import BackgroundTasks

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UNUserNotificationCenterDelegate, BackgroundTimerDelegate {
    
    var window: UIWindow?
    var mainCoordinator:MainCoordinator?
    let notificationCenter = UNUserNotificationCenter.current()
    
    func backgroundTimerTaskExecuted(task: UIBackgroundTaskIdentifier, willRepeat: Bool) {
        guard !willRepeat else {
            return
        }
    }
    func sendRequestRepeatly(){
        BackgroundTimer(delegate: self).executeAfterDelay(delay: 5, repeating: true) {
            let dataDecoded = UserDefaults.standard.object(forKey: "history")
            let decoder = JSONDecoder()
            let arr = try! decoder.decode([HistoryModel].self, from: dataDecoded as! Data)
            if arr.count != 0 {
                for i in 0...arr.count-1 {
                    self.checkCoins(id: arr[i].id, min: arr[i].min, max: arr[i].max) { st in
                        if st != "" {
                            self.scheduleNotification(notificationType: "\(arr[i].name) values \(st)!!!")
                        }
                    }
                }
            }}
    }
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        mainCoordinator = MainCoordinator()
        mainCoordinator?.start()
        window?.rootViewController = mainCoordinator?.navigationController
        window?.makeKeyAndVisible()
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                self.notificationCenter.delegate = self
            }
        }
        sendRequestRepeatly()
    }
    func scheduleNotification(notificationType: String) {
        let content = UNMutableNotificationContent()
        let categoryIdentifire = "Delete Notification Type"
        content.sound = UNNotificationSound.default
        content.body = notificationType
        content.categoryIdentifier = categoryIdentifire
        if (notificationType == "Local Notification with Content")
        {
            let imageName = "Apple"
            guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
            let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
            content.attachments = [attachment]
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        if (notificationType == "Local Notification with Action")
        {
            let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
            let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
            let category = UNNotificationCategory(identifier: categoryIdentifire,
                                                  actions: [snoozeAction, deleteAction],
                                                  intentIdentifiers: [],
                                                  options: [])
            notificationCenter.setNotificationCategories([category])
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "Local Notification" {
        }
        completionHandler()
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    func checkCoins(id:String,min:String,max:String,completion: @escaping(String)->Void){
        let param = ["ids":id,"vs_currencies":"usd"]
        AF.request(URL(string: CoinsAPI.getPrize.rawValue)!, method: .get,parameters: param).responseDecodable(of: [String:PrizeData].self) { response in
            if let _ = response.error {
            } else {
                if let data:Double = response.value?.values.first?.usd{
                    let minD = Double(min)
                    let maxD = Double(max)
                    if (data < minD ?? 0) {
                        completion("decreased")
                    } else if (data > maxD ?? 0) {
                        completion("increased")
                    } else {
                        completion("")
                    }
                }
            }
        }
    }
    func sceneDidEnterBackground(_ scene: UIScene) {
        sendRequestRepeatly()
    }
}




