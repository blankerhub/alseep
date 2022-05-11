//
//  realsleepApp.swift
//  realsleep
//
//  Created by Ar on 5/1/22.
//

import SwiftUI
import BackgroundTasks

@main
struct realsleepApp: App {
    @StateObject private var dataController = DataController()
    init(){
        registerBgTasks()
    }
    var body: some Scene {
        WindowGroup {
            Main()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
    func registerBgTasks(){
        
        let isRefreshTaskScheduleSuccess = BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.asleeptimer.bgtasks.refresh", using: nil) { task in
            // Downcast the parameter to an app refresh task as this identifier is used for a refresh request.
            RefreshHandler().handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        //triggerDebugNotification(message: "bg task registration \(isRefreshTaskScheduleSuccess)")
    }
    
}
