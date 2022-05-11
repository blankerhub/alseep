//
//  Home.swift
//  realsleep
//
//  Created by Ar on 5/1/22.
//

import SwiftUI
import BackgroundTasks

struct Home: View {
    private var notifier = Notifier()
    @StateObject var debugListeners = DebugListeners.debugListeners
    @FetchRequest(sortDescriptors: []) var activities: FetchedResults<Activity>
    @Environment(\.managedObjectContext) var moc
    @Environment(\.scenePhase) var scenePhase
    @State var isButtonOn = false
    @State var countUpTime = 0
    @State var debugLog = ""
    @State var timer: Timer?

    var body: some View {
        GeometryReader { bounds in
            VStack {
                VStack{                    
                    Button(action: onPowerButtonClicked){
                        Image(isButtonOn ? "asleep-on" : "asleep-light")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(30)
                    }
                    .buttonStyle(NeoButtonStyleWithoutHover())
                    if isButtonOn {
                        VStack{Text("sleep timer is on")
                                .foregroundColor(Color.mainLight)
                            Text("stops music when you start sleeping").styleAsCaption().foregroundColor(Color.mainLighest)}
                    }
                    else{
                        VStack{Text("sleep timer is off")
                                .foregroundColor(Color.mainLight)
                            Text("turn on to detect sleep and stop playing").styleAsCaption().foregroundColor(Color.mainLighest)}
                    }
                    HeadingOne(title: "STOP PLAYING")
                    MusicBar()
                    HeadingOne(title: "LAST 7 DAYS")
                    ScrollView{
                        if debugListeners.isShowDebug {
                            Text(debugLog)
                        }
                        else{
                            History()
                        }
                    }
                    
                }
            }
            .frame(width: bounds.size.width, height: bounds.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding(.top, 100)
        }
        .background(Color.neuBackground)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .onAppear(perform: start)
        .onChange(of: scenePhase) { newPhase in
                        if newPhase == .active {
                           print("active")
                        } else if newPhase == .inactive {
                            print("Inactive")
                        } else if newPhase == .background {
                            self.executeBackgroundTasks()
                        }
                    }
    }
    func start(){
        debugLog = "page initiated"
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func executeBackgroundTasks(){
        notifier.triggerDebugNotification(message: "App entered background")
        RefreshHandler().scheduleAppRefresh()
        startTimer()
    }
    
    func onPowerButtonClicked(){
        isButtonOn.toggle()
        //debugLog += "\n" + "sleep timer is turned \(isButtonOn ? "on" : "off")"
        
        
        if isButtonOn {
            //startTimer()
        }
        else{
           //resetCountUp()
        }
    }
    func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
            countUpSleep()
            //todo - run the above in background
        })
    }
    func countUpSleep(){
        self.countUpTime += 5
        notifier.triggerDebugNotification(message: "\n" + "sleep countup in seconds \(self.countUpTime)")
        debugLog += "\n" + "sleep countup in seconds \(self.countUpTime)"
        //todo - check for indicators and make countup to zero
        
        if(self.countUpTime > 60){
            //todo stop music
            debugLog += "\n" + "10 minutes reached - stopping the play"
            resetCountUp()
            isButtonOn = false
        }
    }
    func resetCountUp(){
        timer?.invalidate()
        self.countUpTime = 0;
    }

}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
