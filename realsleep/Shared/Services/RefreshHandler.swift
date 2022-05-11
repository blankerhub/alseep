//
//  RefreshHandler.swift
//  realsleep
//
//  Created by Ar on 5/9/22.
//

import Foundation
import BackgroundTasks

struct RefreshHandler {
    var notifier = Notifier()
    func handleAppRefresh(task: BGAppRefreshTask){
        scheduleAppRefresh()
        notifier.triggerDebugNotification(message: "App refreshed")
        
        task.expirationHandler = {
            // After all operations are cancelled, the completion block below is called to set the task to complete.
           
        }
    }
    func scheduleAppRefresh(){
        let request = BGAppRefreshTaskRequest(identifier: "com.asleeptimer.bgtasks.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 5)
        do {
            try BGTaskScheduler.shared.submit(request)
            notifier.triggerDebugNotification(message: "app refresh scheduled")
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
}
