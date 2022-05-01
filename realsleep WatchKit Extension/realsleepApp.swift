//
//  realsleepApp.swift
//  realsleep WatchKit Extension
//
//  Created by Ar on 5/1/22.
//

import SwiftUI

@main
struct realsleepApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
