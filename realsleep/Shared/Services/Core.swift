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
    static var shared = Core()
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp, order: .reverse)]) var activities: FetchedResults<Activity>
    private var healthDataManager = HealthKitManager.shared
    private var coreDataManager = CoreDataManager.shared
    private var sensorManager = SensorManager.shared
    
    func checkWhetherUserAsleep(context: NSManagedObjectContext) -> Bool{
        getLastActiveTimestamp(context: context)
        return false;
    }
    
    func getLastActiveTimestamp(context: NSManagedObjectContext)-> Date? {
        refreshActivityData(context: context);
        refreshAccelerometerData(context: context)
        //compare the accelerometer reading in the last time interval
        // and insert into activities if active
        
        return activities.first?.timestamp;
    }
    
    func refreshAccelerometerData(context: NSManagedObjectContext){
        if let data = sensorManager.getCurrentAccelerometerReading() {
            coreDataManager.saveAccelerometerData(context: context, data: data)
        }
        else{
            print("no data returned from get current accelerometer reading")
        }
    }
    
    func refreshActivityData(context: NSManagedObjectContext){
        refreshActiveEnergyData(context: context){isCompleted in
            
        }
        refreshStepData(context: context){isCompleted in
            
        }
    }
    func refreshActiveEnergyData(context: NSManagedObjectContext, completionHandler: @escaping (Bool) -> Void){
        coreDataManager.getLatestRecord(context: context, objectType: .ActiveEnergy){isRecordsPresent, latestRecord in
            if isRecordsPresent, let latestRecord = latestRecord as? ActiveEnergy {
                healthDataManager.getSamplesSinceTimeStamp(quantityType: .activeEnergyBurned, startTimeStamp: latestRecord.timestamp){query, results, error in
                    coreDataManager.insert(context: context, objectType: .ActiveEnergy, results: results, completionHandler: completionHandler)
                }
            }
            else{
                healthDataManager.getSamplesSinceTimeStamp(quantityType: .activeEnergyBurned){query, results, error in
                    coreDataManager.insert(context: context, objectType: .ActiveEnergy, results: results, completionHandler: completionHandler)
                    completionHandler(true);
                }
            }
        }
    }
    

    func refreshStepData(context: NSManagedObjectContext, completionHandler: @escaping (Bool) -> Void){
        coreDataManager.getLatestRecord(context: context, objectType: .Steps){isRecordsPresent, latestRecord in
            if isRecordsPresent, let latestRecord = latestRecord as? Steps {
                healthDataManager.getSamplesSinceTimeStamp(quantityType: .stepCount, startTimeStamp: latestRecord.timestamp){query, results, error in
                    coreDataManager.insert(context: context, objectType: .Steps, results: results, completionHandler:  completionHandler)
                    completionHandler(true);
                }
            }
            else{
                healthDataManager.getSamplesSinceTimeStamp(quantityType: .stepCount){query, results, error in
                    coreDataManager.insert(context: context, objectType: .Steps, results: results, completionHandler: completionHandler)
                    completionHandler(true);
                }
            }
        }
    }
    
    func deleteAllActiveEnergyRecords(context: NSManagedObjectContext){
        coreDataManager.deleteAllActiveEnergyRecords(context: context);
    }
    
}
