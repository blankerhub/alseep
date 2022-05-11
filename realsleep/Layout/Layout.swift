//
//  Layout.swift
//  realsleep
//
//  Created by Ar on 5/11/22.
//

import SwiftUI

struct Layout<T1: View, T2: View, T3: View>: View {
    @State var layout = NavType.TOP
    var navItems: [NavItemObject]
    var ViewZero: T1
    var ViewOne: T2
    var ViewTwo: T3

    var body: some View {
        if layout == .TOP{
            TopBarLayout(ViewZero: ViewZero, ViewOne: ViewOne, ViewTwo: ViewTwo, navItems: navItems)
        }
        else if layout == .LEFT {
            SideBarLayout(ViewZero: ViewZero, ViewOne: ViewOne, ViewTwo: ViewTwo, navItems: navItems)
        }
        else{
            
        }
    }
}

struct Layout_Previews: PreviewProvider {
    static var previews: some View {
        Layout(layout: .TOP, navItems: [], ViewZero: Text("View zero"), ViewOne: Text("View one"), ViewTwo: Text("View two"))
    }
}
