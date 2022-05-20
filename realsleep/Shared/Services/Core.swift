//
//  DataManager.swift
//  realsleep
//
//  Created by Ar on 5/11/22.
//

import Foundation
import CoreData
import SwiftUI
import HealthKit

struct Core {
    static let shared = Core()
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp, order: .reverse)]) var activities: FetchedResults<Activity>
    private var healthDataManager = HealthKitManager.shared
    private var coreDataManager = CoreDataManager.shared
    private var sensorManager = SensorManager.shared
    var context: NSManagedObjectContext {
        didSet{
            print("context value is set in core \(context.name)")
            self.coreDataManager.context = context
        }
    }
    init(){
        context = NSManagedObjectContext()
    }
    
    func recordActivity(activity: String){
        let dummyActivity = Activity(context: context);
        dummyActivity.details = activity;
        dummyActivity.timestamp = Date()
        do{
            try context.save();
        }
        catch{
            print(error)
        }
    }
    func checkWhetherUserAsleep() -> Bool{
        getLastActiveTimestamp()
        return false;
    }
    
    func getLastActiveTimestamp()-> Date? {
        //refreshActivityData();
        
        //compare the accelerometer reading in the last time interval
        // and insert into activities if active
        
        return activities.first?.timestamp;
    }
    
    func refreshAccelerometerData(){
        if let data = sensorManager.getCurrentAccelerometerReading() {
            coreDataManager.saveAccelerometerData(data: data)
        }
        else{
            print("no data returned from get current accelerometer reading")
        }
    }
    
    func refreshActivityData(){
        // get latest steps record and save to activities
        healthDataManager.getLatestSample(quantityType: .activeEnergyBurned){query, results, error in
            guard let samples = results as? [HKQuantitySample] else {
                // Handle any errors here.
                return
            }
            let activeEnergy = ActiveEnergy(context: context);
            activeEnergy.timestamp = samples.first!.startDate
            activeEnergy.value = samples.first!.quantity.doubleValue(for: HKUnit.kilocalorie())
            try? context.save()
        }
        healthDataManager.getLatestSample(quantityType: .stepCount){query, results, error in
            guard let samples = results as? [HKQuantitySample] else {
                // Handle any errors here.
                return
            }
            print(samples.first)
            
        }
        
        //get latest active calories record and save to activities
    }
    func refreshActiveEnergyData(){
        //deleteAllActiveEnergyRecords(context: context);
        let fetchRequest: NSFetchRequest<ActiveEnergy>
        fetchRequest = ActiveEnergy.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \ActiveEnergy.timestamp, ascending: false)
        ]
        fetchRequest.fetchLimit = 1
        if let objects = try? context.fetch(fetchRequest) {
            if let latestRecord = objects.first {
                healthDataManager.getSamplesSinceTimeStamp(quantityType: .activeEnergyBurned, startTimeStamp: latestRecord.timestamp){query, results, error in
                    coreDataManager.insertIntoActiveEnergy(results: results)
                }
            }
            else{
                print("no records found for active energy")
                healthDataManager.getSamplesSinceTimeStamp(quantityType: .activeEnergyBurned){query, results, error in
                    coreDataManager.insertIntoActiveEnergy(results: results)
                }
            }
        }
    }

    func deleteRecord(){
        let fetchRequest: NSFetchRequest<Activity>
        fetchRequest = Activity.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "active = true");
        fetchRequest.includesPropertyValues = false
        if let objects = try? context.fetch(fetchRequest) {
            for object in objects {
                context.delete(object)
            }
        }
        try? context.save()
    }
    
    func deleteAllActiveEnergyRecords(){
        let fetchRequest: NSFetchRequest<ActiveEnergy>
        fetchRequest = ActiveEnergy.fetchRequest()
        //fetchRequest.predicate = NSPredicate(format: "active = true");
        fetchRequest.includesPropertyValues = false
        if let objects = try? context.fetch(fetchRequest) {
            for object in objects {
                context.delete(object)
            }
        }
        try? context.save()
    }
    
}
