//
//  ContentView.swift
//  realsleep
//
//  Created by Ar on 5/1/22.
//

import SwiftUI
import BackgroundTasks

enum ViewType {
    case VIEWZERO
    case VIEWONE
    case VIEWTWO
}

enum NavType {
    case TOP
    case RIGHT
    case LEFT
    case BOTTOM
}

class DebugListeners: ObservableObject {
    static let debugListeners = DebugListeners()
    @Published var isShowDebug: Bool = true
    @Published var debugLogs: [String] = ["Logs"]
}


struct Main: View {
    @StateObject var topBarListener = TopBarListeners.topBarListener
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.managedObjectContext) var moc
    private var refreshHandler = RefreshHandler()
    private var notifier = Notifier()
    private var core = Core()
    private var navItems = [ NavItemObject(label: "Home", iconPath: "home-nav-light"),
                             NavItemObject(label: "Settings", iconPath: "setting-nav-light"),
                             NavItemObject(label: "Debug", iconPath: "")]
    init(){
        registerBgTasks()
        self.core.context = moc;
    }
    var body: some View {
        Layout(layout: topBarListener.navType, navItems: navItems, ViewZero: Home(), ViewOne: Settings(), ViewTwo: Debug()).onChange(of: topBarListener.navType){newValue in
            print("navtype changed")
        }.onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
               print("active")
            } else if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .background {
                self.executeBackgroundTasks()	
            }
        }
    }
    
    func executeBackgroundTasks(){
        notifier.triggerDebugNotification(message: "App entered background")
        refreshHandler.scheduleAppRefresh()
    }
    func registerBgTasks(){
        
        let isRefreshTaskScheduleSuccess = BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.asleeptimer.bgtasks.refresh", using: nil) { task in
            // Downcast the parameter to an app refresh task as this identifier is used for a refresh request.
            RefreshHandler().handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        //triggerDebugNotification(message: "bg task registration \(isRefreshTaskScheduleSuccess)")
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
            .previewDevice("iPhone 13 Pro")
    }
}
