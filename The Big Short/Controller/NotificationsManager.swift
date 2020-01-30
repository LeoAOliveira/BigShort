//
//  NotificationsManager.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 17/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

public class NotificationsManager: NSObject, UNUserNotificationCenterDelegate {
    
    static func setNotifications(notiifcations: UNUserNotificationCenter, data: [Wallet]) {
        
        notiifcations.removeAllPendingNotificationRequests()
        
        if data[0].notifications == true{
            
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.getNotificationSettings { (settings) in
                
                if settings.authorizationStatus == .authorized {
                    
                    // MARK: - Opening
                    let content1 = UNMutableNotificationContent()
                    content1.title = NSString.localizedUserNotificationString(forKey: "Mercado aberto", arguments: nil)
                    content1.sound = UNNotificationSound.default
                    
                    var dateConponents1 = DateComponents()
                    dateConponents1.hour = 10
                    dateConponents1.minute = 00
                    
                    
                    let trigger1 = UNCalendarNotificationTrigger(dateMatching: dateConponents1, repeats: false)
                    
                    let request1 = UNNotificationRequest(identifier: "market1", content: content1, trigger: trigger1)
                    
                    let center1 = UNUserNotificationCenter.current()
                    center1.add(request1) { (error : Error?) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                    
                    // MARK: - Closing
                    let content2 = UNMutableNotificationContent()
                    content2.title = NSString.localizedUserNotificationString(forKey: "Mercado fechado", arguments: nil)
                    content2.sound = UNNotificationSound.default
                    
                    var dateConponents2 = DateComponents()
                    dateConponents2.hour = 17
                    dateConponents2.minute = 00
                    
                    
                    let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateConponents2, repeats: false)
                    
                    let request2 = UNNotificationRequest(identifier: "market2", content: content2, trigger: trigger2)
                    
                    let center2 = UNUserNotificationCenter.current()
                    center2.add(request2) { (error : Error?) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                    
                } else {
                    print("Impossível mandar notificação - permissão negada")
                }
            }
            
        }
    }
}
