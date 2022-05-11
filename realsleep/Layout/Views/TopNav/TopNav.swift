//
//  TopNav.swift
//  realsleep
//
//  Created by Ar on 5/1/22.
//

import SwiftUI

struct TopNav: View {
    @Binding var activeView: ViewType
    @State var navItemObjects: [NavItemObject]
    var body: some View {
        HStack(spacing: 25){
            Button(action: onHomeClicked){
                TopNavItem(itemText: navItemObjects.first?.label ?? "", isActive: self.activeView == .VIEWZERO).animation(.easeInOut)
            }
            Button(action: {() -> Void in activeView = .VIEWONE}){
                TopNavItem(itemText: navItemObjects[1].label, isActive: self.activeView == .VIEWONE).animation(.easeInOut)
            }
            Button(action: {() -> Void in activeView = .VIEWTWO}){
                TopNavItem(itemText: navItemObjects[2].label, isActive: self.activeView == .VIEWTWO).animation(.easeInOut)
            }
            Spacer()
        }
        .padding(.leading, 20)
    }
    func onHomeClicked(){
        self.activeView = ViewType.VIEWZERO
    }
}

struct TopNav_Previews: PreviewProvider {
    static var previews: some View {
        TopNav(activeView: .constant(.VIEWONE), navItemObjects: [])
    }
}
