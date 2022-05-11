//
//  ContentView.swift
//  realsleep
//
//  Created by Ar on 5/1/22.
//

import SwiftUI


class DebugListeners: ObservableObject {
    static let debugListeners = DebugListeners()
    @Published var isShowDebug: Bool = true
}


enum ViewType {
    case HISTORY
    case HOME
    case SETTINGS
}

extension Color {
    static let neuBackground = Color(hex: "f0f0f3")
    static let dropShadow = Color(hex: "aeaec0").opacity(0.4)
    static let dropLight = Color(hex: "ffffff")
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}

struct TitleStyle: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.system(.title, design: .rounded))
    }
}

extension View {
    func styleAsTitle() -> some View {
        modifier(TitleStyle())
    }
}


struct Main: View {
    @StateObject var topBarListener = TopBarListeners.topBarListener
    @State var activeView = ViewType.HOME
    @State var viewState = CGSize.zero
    @State var centerState = CGSize.zero
    @State var centerTransitionStateWidth: CGFloat = CGFloat.zero
    let screenSize = UIScreen.main.bounds
    @State var screenWidth = CGFloat.zero
    @State var screenHeight = CGFloat.zero
    
    var body: some View {
        ZStack{
            Color.neuBackground.edgesIgnoringSafeArea(.all)
            VStack{
                if !topBarListener.isHideTopBar {
                    HStack{
                        TopNav(activeView: $activeView)
                    }
                    .onChange(of: activeView, perform: onTopNavTapped)
                }
                ZStack {
                    Home()
                        .offset(x: self.activeView == ViewType.HOME ? 0 : -screenWidth)
                        .offset(x: activeView != .SETTINGS ? viewState.width : 0)
                        .animation(.easeInOut)
                    History()
                        .animation(.easeInOut)
                        .offset(x: activeView == .HISTORY ? centerState.width : centerTransitionStateWidth)
                    Settings()
                        .offset(x: self.activeView == ViewType.SETTINGS ? 0 : screenWidth)
                        .offset(x: activeView != .HOME ? viewState.width : 0)
                        .animation(.easeInOut)
                }
                
                .gesture(
                    (self.activeView == ViewType.HISTORY) ?
                        
                        DragGesture().onChanged { value in
                            
                            self.viewState = value.translation
                            self.centerState = value.translation
                        }
                        .onEnded { value in
                            if value.predictedEndTranslation.width > screenWidth / 2 {
                                centerTransitionStateWidth = screenWidth
                                self.activeView = ViewType.HOME
                                self.viewState = .zero
                                
                            }
                            else if value.predictedEndTranslation.width < -screenWidth / 2 {
                                self.activeView = ViewType.SETTINGS
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
                            case .HOME:
                                guard value.translation.width < 1 else { return }
                                self.viewState = value.translation
                                self.centerTransitionStateWidth = value.translation.width + screenWidth
                            case .SETTINGS:
                                guard value.translation.width > 1 else { return }
                                self.viewState = value.translation
                                self.centerTransitionStateWidth = value.translation.width - screenWidth
                            case.HISTORY:
                                self.viewState = value.translation
                                
                            }
                            
                        }
                        
                        .onEnded { value in
                            switch self.activeView {
                            case .HOME:
                                if value.predictedEndTranslation.width < -screenWidth / 2 {
                                    self.activeView = .HISTORY
                                    self.viewState = .zero
                                    self.centerState = .zero
                                }
                                else {
                                    self.viewState = .zero
                                }
                            case .SETTINGS:
                                if value.predictedEndTranslation.width > screenWidth / 2 {
                                    self.activeView = .HISTORY
                                    self.viewState = .zero
                                    self.centerState = .zero
                                }
                                else {
                                    self.viewState = .zero
                                }
                            case .HISTORY:
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
        self.activeView = .HOME
        self.centerTransitionStateWidth = screenWidth
    }
    func onTopNavTapped(newValue: ViewType){
        print("top nav tapped")
        self.viewState = .zero
        if self.activeView == ViewType.HOME {
            centerTransitionStateWidth = screenWidth
        }
        else if self.activeView == ViewType.SETTINGS {
            centerTransitionStateWidth = -screenWidth
        }
        else{
            self.centerState = .zero
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
            .previewDevice("iPhone 13 Pro")
    }
}
