//
//  ContentView.swift
//  realsleep
//
//  Created by Ar on 5/1/22.
//

import SwiftUI

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
}


struct Main: View {
    @StateObject var topBarListener = TopBarListeners.topBarListener
    private var navItems = [ NavItemObject(label: "Home", iconPath: "home-nav-light"),
                             NavItemObject(label: "Settings", iconPath: "setting-nav-light"),
                             NavItemObject(label: "History", iconPath: "")]
    var body: some View {
        Layout(layout: topBarListener.navType, navItems: navItems, ViewZero: Home(), ViewOne: History(), ViewTwo: EmptyView())
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
            .previewDevice("iPhone 13 Pro")
    }
}
