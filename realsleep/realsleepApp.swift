//
//  realsleepApp.swift
//  realsleep
//
//  Created by Ar on 5/1/22.
//

import SwiftUI

@main
struct realsleepApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            Main()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
