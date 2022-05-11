//
//  MainWithSideBar.swift
//  realsleep
//
//  Created by Ar on 5/4/22.
//

import SwiftUI
import HealthKit
import CoreMotion
import BackgroundTasks


enum PageType {
    case HOME
    case SETTINGS
    case DEBUG
}



struct SideBarLayout<T1: View, T2: View, T3: View>: View {
    @State var selectedPage: ViewType = .VIEWZERO
    let sideBarWidth = 0.1
    var ViewZero: T1
    var ViewOne: T2
    var ViewTwo: T3
    var navItems: [NavItemObject]
    
    var body: some View {
        
        //Color.neuBackground.edgesIgnoringSafeArea(.all)
        GeometryReader{g in
            HStack(spacing: 0){
                SideNav(activeView: $selectedPage, navItems: navItems, containerSize: g.size).frame(width: g.size.width * sideBarWidth, height: g.size.height)
                    .padding(.leading, 10)
                    .background(Color.neuBackground)
                VStack(){
                    if selectedPage == .VIEWZERO{
                        ViewZero.transition(.asymmetric(insertion: .move(edge:.leading),removal: .move(edge: .trailing))).animation(.easeInOut)
                    }
                    else if selectedPage == .VIEWONE {
                        ViewOne
                            .transition(.asymmetric(insertion: .move(edge:.trailing),removal: .move(edge: .leading))).animation(.easeInOut)
                        
                    }
                    else if selectedPage == .VIEWTWO {
                        ViewTwo
                    }
                }
                .frame(width: g.size.width * (1 - sideBarWidth), height: g.size.height)
            }
            .frame(width: .infinity, height: .infinity, alignment: .center)
        }
        .onAppear(perform: start)
        .background(Color.neuBackground)
        
        
    }
    func start(){
        //registerBackgroundTasks()
    }
}


struct MainWithSideBar_Previews: PreviewProvider {
    static var previews: some View {
        SideBarLayout(ViewZero: Text("View zero"), ViewOne: Text("View one"), ViewTwo: Text("View two"), navItems: [])
    }
}
