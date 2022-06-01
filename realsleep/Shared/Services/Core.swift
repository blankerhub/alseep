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


extension Array where Element: FloatingPoint {

    func sum() -> Element {
        return self.reduce(0, +)
    }

    func avg() -> Element {
        return self.sum() / Element(self.count)
    }

    func std() -> Element {
        let mean = self.avg()
        let v = self.reduce(0, { $0 + ($1-mean)*($1-mean) })
        return sqrt(v / (Element(self.count) - 1))
    }

}



struct Core {
    static var shared = Core()
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp, order: .reverse)]) var activities: FetchedResults<Activity>
    private var healthDataManager = HealthKitManager.shared
    private var coreDataManager = CoreDataManager.shared
    private var sensorManager = SensorManager.shared
    private var logHelper = LogHelper.shared
    func checkWhetherUserAsleep(context: NSManagedObjectContext, numberOfMinutes: Int = 20, completionHandler: (Bool) -> Void) {
        getLastActiveTimestamp(context: context, numberOfMinutes: numberOfMinutes){lastActiveTimeStamp in
            if let lastActiveTimeStamp = lastActiveTimeStamp {
                logHelper.debugLog(message: "last active timestamp is \(lastActiveTimeStamp)")
                let now = Date();
                let timeInterval = Int(now.timeIntervalSince(lastActiveTimeStamp)) / 60;
                completionHandler(timeInterval > numberOfMinutes);
            }
            else{
                logHelper.debugLog(message: "last active timestamp is not present")
                completionHandler(false);
            }
        }
    }
    
    func getLastActiveTimestamp(context: NSManagedObjectContext, numberOfMinutes: Int, completionHandler: (Date?) -> Void) {
        logHelper.debugLog(message: "get last active timestamp started")
        refreshActiveData(context: context);
        refreshAccelerometerData(context: context)
        performActivityCheckUsingAccelerometerData(context: context,numberOfMinutes: numberOfMinutes);
        performActivityCheckUsingActiveData(context: context,numberOfMinutes: numberOfMinutes);
        coreDataManager.getLatestRecord(context: context, objectType: .Activity){isRecordsPresent, latestRecord in
            if isRecordsPresent, let latestRecord = latestRecord as? Activity {
                completionHandler(latestRecord.timestamp);
            }
        }
    }
    
    func performActivityCheckUsingAccelerometerData(context: NSManagedObjectContext, numberOfMinutes: Int)
    {
        logHelper.debugLog(message: "performing activity check using accelerometer data")
        let endDateTime = Date();
        let startDateTime = Calendar.current.date(byAdding: .minute, value: -numberOfMinutes, to: endDateTime) ?? Date()
        if let objects = coreDataManager.fetchWithinDateRange(context: context, entityName: "PhoneAccData", startDateTime: startDateTime,
                                                              endDateTime: endDateTime, predicates: []) {
            var xValues: [Double] = [];
            var yValues: [Double] = [];
            var zValues: [Double] = [];
            let numberOfRecords = objects.count;
            for object in objects {
                //calculate variance
                if let accData = object as? PhoneAccData{
                    xValues.append(abs(accData.xvalue * 100));
                    yValues.append(abs(accData.yvalue * 100));
                    zValues.append(abs(accData.zvalue * 100));
                }
            }
            let xstd = xValues.std();
            let ystd = yValues.std();
            let zstd = zValues.std();
            logHelper.debugLog(message: "x xvalues: \(xValues)")
            logHelper.debugLog(message: "x average: \(xValues.avg())")
            logHelper.debugLog(message: "standard deviation: \(xstd) \(ystd) \(zstd)")
            if(xstd != 0 && xstd < 2 && ystd < 2 && zstd < 2){
                logHelper.debugLog(message: "no activity detected from accelerometer data")
            }
            else{
                logHelper.debugLog(message: "activity detected from accelerometer data")
                coreDataManager.saveActivityData(context: context, details: "phoneAccData")
            }
        }
        //compare the accelerometer reading in the last time interval and insert into activities if active
        
    }
    
    func performActivityCheckUsingActiveData(context: NSManagedObjectContext, numberOfMinutes: Int){
        //check activitydata - active energy and steps average for the specified time interval and insert into activities if active
        logHelper.debugLog(message: "performing activity check using active data")
        let endDateTime = Date();
        let startDateTime = Calendar.current.date(byAdding: .minute, value: -numberOfMinutes, to: endDateTime) ?? Date()
        if let objects = coreDataManager.fetchWithinDateRange(context: context, entityName: "ActiveEnergy", startDateTime: startDateTime,
                                                              endDateTime: endDateTime, predicates: []) {
            var energyValues: [Double] = [];
            for object in objects {
                //calculate average
                if let activeEnergyData = object as? ActiveEnergy{
                    energyValues.append(activeEnergyData.value)
                }
            }
            logHelper.debugLog(message: "energy values: \(energyValues)")
            let averageActiveEnergy = energyValues.avg();
            logHelper.debugLog(message: "average active energy for the given time period: \(averageActiveEnergy)")
            if(averageActiveEnergy < 0.1){
                logHelper.debugLog(message: "no activity detected from active energy data")
            }
            else{
                logHelper.debugLog(message: "activity detected from active energy data")
                coreDataManager.saveActivityData(context: context, details: "activeEnergy")
            }
        }
    }
    
    func refreshAccelerometerData(context: NSManagedObjectContext){
        logHelper.debugLog(message: "refreshing accelerometer data")
        if let data = sensorManager.getCurrentAccelerometerReading() {
            coreDataManager.saveAccelerometerData(context: context, data: data)
        }
        else{
            logHelper.debugLogError(message: "no data returned from get current accelerometer reading")
        }
    }
    
    func refreshActiveData(context: NSManagedObjectContext){
        refreshActiveEnergyData(context: context){isCompleted in
            
        }
//        refreshStepData(context: context){isCompleted in
//
//        }
    }
    func refreshActiveEnergyData(context: NSManagedObjectContext, completionHandler: @escaping (Bool) -> Void){
        logHelper.debugLog(message: "refreshing active energy data")
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
        logHelper.debugLog(message: "refreshing step data")
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
