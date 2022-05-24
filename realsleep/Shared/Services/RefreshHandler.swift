//
//  RefreshHandler.swift
//  realsleep
//
//  Created by Ar on 5/9/22.
//

import Foundation
import BackgroundTasks
import CoreData

struct RefreshHandler {
    var notifier = Notifier()
    private var core = Core()
    func handleAppRefresh(context: NSManagedObjectContext, task: BGAppRefreshTask){
        scheduleAppRefresh()
        let isUserAsleep = core.checkWhetherUserAsleep(context: context)
        if(isUserAsleep){
            notifier.triggerDebugNotification(message: "User is asleep. Stopping the play")
            //todo - stop the play
        }
        else{
            notifier.triggerDebugNotification(message: "User is not asleep. Continuing the play")
        }
        notifier.triggerDebugNotification(message: "App refreshed")
        task.expirationHandler = {
            notifier.triggerDebugNotification(message: "App refresh expired")
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
