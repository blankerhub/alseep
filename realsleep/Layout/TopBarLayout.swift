//
//  MainWithTopBar.swift
//  realsleep
//
//  Created by Ar on 5/4/22.
//

import SwiftUI


struct TopBarLayout<T1: View, T2: View, T3: View>: View {
    @StateObject var topBarListener = TopBarListeners.topBarListener
    @State var activeView = ViewType.VIEWZERO
    @State var viewState = CGSize.zero
    @State var centerState = CGSize.zero
    @State var centerTransitionStateWidth: CGFloat = CGFloat.zero
    let screenSize = UIScreen.main.bounds
    @State var screenWidth = CGFloat.zero
    @State var screenHeight = CGFloat.zero
    var ViewZero: T1
    var ViewOne: T2
    var ViewTwo: T3
    var navItems: [NavItemObject]
    
    var body: some View {
        ZStack{
            Color.neuBackground.edgesIgnoringSafeArea(.all)
            VStack{
                if !topBarListener.isHideTopBar {
                    HStack{
                        TopNav(activeView: $activeView, navItemObjects: navItems)
                    }
                    .onChange(of: activeView, perform: onTopNavTapped)
                }
                ZStack {
                    ViewZero
                        .offset(x: self.activeView == ViewType.VIEWZERO ? 0 : -screenWidth)
                        .offset(x: activeView != .VIEWTWO ? viewState.width : 0)
                        .animation(.easeInOut)
                    ViewOne
                        .animation(.easeInOut)
                        .offset(x: activeView == .VIEWONE ? centerState.width : centerTransitionStateWidth)
                    ViewTwo
                        .offset(x: self.activeView == ViewType.VIEWTWO ? 0 : screenWidth)
                        .offset(x: activeView != .VIEWZERO ? viewState.width : 0)
                        .animation(.easeInOut)
                }
                
                .gesture(
                    (self.activeView == ViewType.VIEWONE) ?
                    
                    DragGesture().onChanged { value in
                        
                        self.viewState = value.translation
                        self.centerState = value.translation
                    }
                        .onEnded { value in
                            if value.predictedEndTranslation.width > screenWidth / 2 {
                                centerTransitionStateWidth = screenWidth
                                self.activeView = ViewType.VIEWZERO
                                self.viewState = .zero
                                
                            }
                            else if value.predictedEndTranslation.width < -screenWidth / 2 {
                                self.activeView = ViewType.VIEWTWO
                                centerTransitionStateWidth = -screenWidth
                                self.viewState = .zero
                            }
                            
                            else {
                                self.viewState = .zero
                                self.centerState = .zero
                            }
                            
                        }
                    : DragGesture().onChanged { value in
                        switch self.activeView {
                        case .VIEWZERO:
                            guard value.translation.width < 1 else { return }
                            self.viewState = value.translation
                            self.centerTransitionStateWidth = value.translation.width + screenWidth
                        case .VIEWTWO:
                            guard value.translation.width > 1 else { return }
                            self.viewState = value.translation
                            self.centerTransitionStateWidth = value.translation.width - screenWidth
                        case.VIEWONE:
                            self.viewState = value.translation
                            
                        }
                        
                    }
                    
                        .onEnded { value in
                            switch self.activeView {
                            case .VIEWZERO:
                                if value.predictedEndTranslation.width < -screenWidth / 2 {
                                    self.activeView = .VIEWONE
                                    self.viewState = .zero
                                    self.centerState = .zero
                                }
                                else {
                                    self.viewState = .zero
                                    self.centerTransitionStateWidth = screenWidth;
                                }
                            case .VIEWTWO:
                                if value.predictedEndTranslation.width > screenWidth / 2 {
                                    self.activeView = .VIEWONE
                                    self.viewState = .zero
                                    self.centerState = .zero
                                }
                                else {
                                    self.viewState = .zero
                                    self.centerTransitionStateWidth = -screenWidth;
                                }
                            case .VIEWONE:
                                self.viewState = .zero
                                
                            }
                        }
                )
            }
        }
        .onAppear(perform: start)
        .background(Color.neuBackground)
    }
    func start(){
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height
        self.activeView = .VIEWZERO
        self.centerTransitionStateWidth = screenWidth
    }
    func onTopNavTapped(newValue: ViewType){
        print("top nav tapped")
        self.viewState = .zero
        if self.activeView == ViewType.VIEWZERO {
            centerTransitionStateWidth = screenWidth
        }
        else if self.activeView == ViewType.VIEWTWO {
            centerTransitionStateWidth = -screenWidth
        }
        else{
            self.centerState = .zero
        }
    }
}

struct MainWithTopBar_Previews: PreviewProvider {
    static var previews: some View {
        TopBarLayout(ViewZero: Text("View zero"), ViewOne: Text("View one"), ViewTwo: Text("View two"), navItems: [ NavItemObject(label: "Home", iconPath: "home-nav-light"),NavItemObject(label: "Settings", iconPath: "setting-nav-light"),NavItemObject(label: "History", iconPath: "")])
    }
}
