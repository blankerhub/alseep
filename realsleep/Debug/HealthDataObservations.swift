//
//  HealthDataObserver.swift
//  realsleep
//
//  Created by Ar on 5/14/22.
//

import SwiftUI
import CoreData

struct HealthDataObservations: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp, order: .reverse)]) var activities: FetchedResults<Activity>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp, order: .reverse)]) var activeEnergyRecords: FetchedResults<ActiveEnergy>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp, order: .reverse)]) var accelerometerData: FetchedResults<PhoneAccData>
    @State private var core = Core.shared;
    @State var isLoading = false;
    @State var message: String? = nil;
    @StateObject var debugListeners = DebugListeners.debugListeners
    @Environment(\.managedObjectContext) var moc;
    var body: some View {
        VStack{
            HStack{
                Button(action: onRefreshClicked){
                    HStack{
                        Image(systemName: "arrow.clockwise")
                        Text("Refresh")
                    }.padding(10)
                }
                Button(action: OnDeleteAllClicked){
                    HStack{
                        Image(systemName: "trash")
                        Text("Delete all")
                    }.padding(10)
            }
            }
            
            if(isLoading){
                Text("loading...")
            }
            else{
                if let message = message {
                Text(message)
                }
            }
            List {
                ForEach(activeEnergyRecords) {activity in
                    Text(String(format: "%.2f",activity.value) + " " + formatDate(date: activity.timestamp))
                }
            }
    //        List {
    //            ForEach(accelerometerData) {item in
    //                Text(String(item.xvalue) + " " + formatDate(date: item.timestamp))
    //                //Text("x: " + String(item.xvalue) + "y: " + String(item.yvalue) + "z: " + String(item.zvalue) + " " + formatDate(date: item.timestamp))
    //            }
    //        }
        }

    }
    func onRefreshClicked(){
        self.message = nil;
        self.isLoading = true;
        core.refreshActiveEnergyData(context: moc){isCompleted in
            self.isLoading = false;
            if(isCompleted){
                self.message = "fetch successful";
            }
            else{
                self.message = "fetch failed";
            }
        }
        //core.refreshAccelerometerData()
    }
    func OnDeleteAllClicked(){
        core.deleteAllActiveEnergyRecords(context: moc)
    }
    func formatDate(date: Date?) -> String{
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YY/MM/dd hh:mm:ss"
            return dateFormatter.string(from: date)
        }
        else {
            return "NA";
        }

    }
}

struct HealthDataObserver_Previews: PreviewProvider {
    static var previews: some View {
        HealthDataObservations()
    }
}

//        List {
//            ForEach(activities) {activity in
//                Text(activity.details! + formatDate(date: activity.timestamp))
//            }
//        }

