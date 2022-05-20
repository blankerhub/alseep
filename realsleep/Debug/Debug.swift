//
//  Debug.swift
//  realsleep
//
//  Created by Ar on 5/14/22.
//

import SwiftUI

struct Debug: View {
    @State private var core = Core.shared;
    @StateObject var debugListeners = DebugListeners.debugListeners
    @Environment(\.managedObjectContext) var moc {
        didSet{
            print("moc value is set in debug")
            core.context = moc;
        }
    }
    init(){
        print("moc value is assgined to context in debug")
        print("moc value \(moc.name)")
        self.core.context = moc;
    }
    var body: some View {
        VStack{
            Button(action: onRefreshClicked){
                Image(systemName: "arrow.clockwise")
                    .padding(10)
            }
            HealthDataObservations()
        }.onAppear(perform: executeOnAppear)
        
    }
    func executeOnAppear(){
        print("moc value is assgined to context in debug appear")
        print("moc value \(moc.name)")
        self.core.context = moc;
    }
    
    func onRefreshClicked(){
        core.refreshActiveEnergyData()
        //core.refreshAccelerometerData()
    }
}

struct Debug_Previews: PreviewProvider {
    static var previews: some View {
        Debug()
    }
}
