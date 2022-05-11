//
//  CoreData.swift
//  realsleep
//
//  Created by Ar on 5/4/22.
//
import Foundation
import SwiftUI
import CoreData

struct CoreData: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp, order: .reverse)]) var activities: FetchedResults<Activity>
    @Environment(\.managedObjectContext) var moc
    init() {
        let request: NSFetchRequest<Activity> = Activity.fetchRequest()
        //request.predicate = NSPredicate(format: "active = true")

        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Activity.timestamp, ascending: false)
        ]

        request.fetchLimit = 10
        _activities = FetchRequest(fetchRequest: request)
    }
    var body: some View {
        
        VStack {
            Button(action:addDummyActivity){
                Text("Add dummy activity")
            }
            Text("Total records: \(activities.count)")
            if(!activities.isEmpty){
                    List(activities) { activity in
                        Text(activity.details ?? "Unknown")
                }
            }
            Text(getLatestTimeStamp())
           
        }
    }
    func addDummyActivity(){
        print("adding dummy activity")
        let dummyActivity = Activity(context: moc);
        dummyActivity.details = "dummy activity";
        dummyActivity.timestamp = Date()
        do{
            try moc.save();
        }
        catch{
            print(error)
        }
        
    }
    func getLatestTimeStamp()-> String {
        
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "YY/MM/dd hh:mm:ss"

        // Convert Date to String
        return dateFormatter.string(from: activities.first?.timestamp ?? Date())
    }
    
}

struct CoreData_Previews: PreviewProvider {
    static var previews: some View {
        CoreData()
    }
}
