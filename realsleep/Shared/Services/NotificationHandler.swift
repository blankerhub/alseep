//
//  NotificationHandler.swift
//  realsleep
//
//  Created by Ar on 5/9/22.
//

import Foundation
import UserNotifications

struct Notifier {
    
    func triggerDebugNotification(message: String){
        let content = UNMutableNotificationContent()
        content.title = "Debug"
        content.subtitle = message
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}
