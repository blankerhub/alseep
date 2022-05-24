//
//  CoreDataManager.swift
//  realsleep
//
//  Created by Ar on 5/15/22.
//

import Foundation
import HealthKit
import CoreData
import CoreMotion

enum ObjectType {
    case Activity
    case Steps
    case ActiveEnergy
    case PhoneAccData
}

struct CoreDataManager {
    static var shared = CoreDataManager()
    
    func getLatestRecord(context: NSManagedObjectContext, objectType: ObjectType, completionHandler: (Bool, NSManagedObject?) -> Void){
        var isRecordsPresent = false;
        var latestRecord: NSManagedObject? = nil;
        switch(objectType){
        case .Steps:
            let fetchRequest: NSFetchRequest<Steps>
            fetchRequest = Steps.fetchRequest()
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \Steps.timestamp, ascending: false)
            ]
            fetchRequest.fetchLimit = 1
            if let objects = try? context.fetch(fetchRequest) {
                if let firstRecord = objects.first {
                    isRecordsPresent = true;
                    latestRecord = firstRecord;
                }
                completionHandler(isRecordsPresent,latestRecord)
            }
            else{
                completionHandler(isRecordsPresent, latestRecord)
            }
        case  .ActiveEnergy:
            let fetchRequest: NSFetchRequest<ActiveEnergy>
            fetchRequest = ActiveEnergy.fetchRequest()
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \ActiveEnergy.timestamp, ascending: false)
            ]
            fetchRequest.fetchLimit = 1
            if let objects = try? context.fetch(fetchRequest) {
                if let firstRecord = objects.first {
                    isRecordsPresent = true;
                    latestRecord = firstRecord;
                }
                completionHandler(isRecordsPresent,latestRecord)
            }
            else{
                completionHandler(isRecordsPresent, latestRecord)
            }
        default:
            completionHandler(isRecordsPresent, latestRecord)
        }
    }
    
    func insert(context: NSManagedObjectContext, objectType: ObjectType, results: [HKSample]?, completionHandler: (Bool) -> Void){
        
        guard let samples = results as? [HKQuantitySample] else {
            // Handle any errors here.
            print("no samples found")
            return
        }
        print("number of samples is \(samples.count)")
        for sample in samples {
            let arguments = ["timestamp": sample.startDate as NSDate,"value": sample.quantity.doubleValue(for: HKUnit.kilocalorie()) as NSObject]
            if let objects = fetchWithPredicate(context: context, entityName: "ActiveEnergy", argumentArray: arguments) {
                for object in objects {
                    context.delete(object)
                }
            }
            try? context.save()
            
            let recordToBeInserted = ActiveEnergy(context: context)
            recordToBeInserted.timestamp = sample.startDate
            recordToBeInserted.value = sample.quantity.doubleValue(for: HKUnit.kilocalorie())
            recordToBeInserted.id = UUID()
            do{
                try context.save()
                completionHandler(true)
            }
            catch{
                print(error)
                completionHandler(false)
            }
        }
    }
    
    func fetchWithPredicate(context: NSManagedObjectContext, entityName: String, argumentArray: [String: NSObject])  -> [NSManagedObject]?  {
        var subPredicates : [NSPredicate] = []
        for (key, value) in argumentArray {
            let subPredicate = NSPredicate(format: "%K == %@", key, value)
            subPredicates.append(subPredicate)
        }

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)
        if let objects = try? context.fetch(fetchRequest){
            return objects;
        }
        else{
            return nil;
        }
    }
    
    func saveAccelerometerData(context: NSManagedObjectContext, data: CMAccelerometerData){
        print("executing save accelerometer data")
        print("context: \(context) ")
        print("data: \(data.acceleration)")
        let dataToBeSaved = PhoneAccData(context: context);
        dataToBeSaved.id = UUID()
        dataToBeSaved.timestamp = Date()
        dataToBeSaved.xvalue = data.acceleration.x;
        dataToBeSaved.yvalue = data.acceleration.y;
        dataToBeSaved.zvalue = data.acceleration.z;
        do{
             try context.save()
        }
        catch{
            print("unable to save accelerometer data")
            print(error)
        }
    }
    
    func deleteAllActiveEnergyRecords(context: NSManagedObjectContext){
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
    
    
    
    
    
    
    
    func recordActivity(context: NSManagedObjectContext, activity: String){
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
    func deleteRecord(context: NSManagedObjectContext){
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
}
