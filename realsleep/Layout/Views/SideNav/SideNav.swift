//
//  SideNav.swift
//  realsleep
//
//  Created by Ar on 5/4/22.
//

import SwiftUI

struct SideNav: View {
    @Binding var activeView: ViewType
    @StateObject var debugListeners = DebugListeners.debugListeners
    @State var navItems: [NavItemObject]
    let containerSize: CGSize
    var body: some View {
        ZStack{
            VStack(spacing: 65){
                Button(action: {activeView = ViewType.VIEWZERO}){HStack{Image(navItems[0].iconPath).resizable().frame(width: containerSize.width * 0.05, height: containerSize.width * 0.05)
                }}.buttonStyle(NeoButtonStyle())
                Button(action: {activeView = ViewType.VIEWONE}){Image(navItems[1].iconPath).resizable().frame(width: containerSize.width * 0.06, height: containerSize.width * 0.06)}.buttonStyle(NeoButtonStyle())
                if debugListeners.isShowDebug {
                    Button(action: {activeView = ViewType.VIEWTWO}){Image(navItems[2].iconPath).resizable().frame(width: containerSize.width * 0.06, height: containerSize.width * 0.06)}.buttonStyle(NeoButtonStyle())
                }
                
            }
        }
        .zIndex(3)
        .padding(.leading, 10)
        .background(Color.neuBackground)
        
    }
}

struct SideNav_Previews: PreviewProvider {
    static var previews: some View {
        SideNav(activeView: .constant(.VIEWONE), navItems: [], containerSize: CGSize())
    }
}
