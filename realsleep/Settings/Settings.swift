//
//  Settings.swift
//  realsleep
//
//  Created by Ar on 5/1/22.
//

import SwiftUI


class TopBarListeners: ObservableObject {
    static let topBarListener = TopBarListeners()
    @Published var isHideTopBar: Bool = false
    @Published var navType: NavType = NavType.TOP
}

struct Settings: View {
    @ObservedObject var topBarListener: TopBarListeners  = TopBarListeners.topBarListener
    var body: some View {
        GeometryReader { bounds in
            VStack {
                Button(action: {topBarListener.navType = NavType.LEFT}){
                    Text("toggle left")
                }
                Button(action: {topBarListener.navType = NavType.TOP}){
                    Text("toggle top")
                }
                Button(action: {topBarListener.navType = NavType.BOTTOM}){
                    Text("toggle bottom")
                }
//                    NavigationView{
//                        ZStack{
//                            Color.neuBackground.edgesIgnoringSafeArea(.all)
//                            VStack(alignment: .leading){
//                                NavigationLink(destination: Text("Second View")) {
//                                    Button(action: onNavItemClicked){
//                                        Text("Click the nav")
//                                    }
//                                }
//                                NavigationLink(destination: ZStack{
//                                    Color.neuBackground.edgesIgnoringSafeArea(.all)
//                                    Text("Second View")
//                                }) {
//                                    Text("Hello, World!")
//                                }.simultaneousGesture(TapGesture().onEnded{
//                                    onNavItemClicked()
//                                })
//                                NavigationLink(destination: Text("Second View")) {
//                                    Text("Hello, World!")
//                                }
//                                NavigationLink(destination: Text("Second View")) {
//                                    Text("Hello, World!")
//                                }
//                                NavigationLink(destination: Text("Second View")) {
//                                    Text("Hello, World!")
//                                }
//                                NavigationLink(destination: Text("Second View")) {
//                                    Text("Hello, World!")
//                                }
//                                NavigationLink(destination: Text("Second View")) {
//                                    Text("Hello, World!")
//                                }
//                            }}
//                    }
            }
            .frame(width: bounds.size.width, height: bounds.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        .background(Color.neuBackground)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    
    }
    func onNavItemClicked(){
        topBarListener.isHideTopBar.toggle()
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
