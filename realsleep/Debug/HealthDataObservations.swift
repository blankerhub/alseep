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
    var body: some View {
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

