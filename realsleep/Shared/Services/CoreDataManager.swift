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

struct CoreDataManager {
    static var shared = CoreDataManager()
    var context: NSManagedObjectContext{
        didSet{
            print("context value is set in core data manager \(context.name)")
        }
    }
    init(){
        context = NSManagedObjectContext()
    }
    
    func insertIntoActiveEnergy(results: [HKSample]?){
        guard let samples = results as? [HKQuantitySample] else {
            // Handle any errors here.
            print("no samples found")
            return
        }
        print("number of samples is \(samples.count)")
        for sample in samples {
            let arguments = ["timestamp": sample.startDate as NSDate,"value": sample.quantity.doubleValue(for: HKUnit.kilocalorie()) as NSObject]
            if let objects = fetchWithPredicate(entityName: "ActiveEnergy", argumentArray: arguments) {
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
            }
            catch{
                print(error)
            }
        }
    }
    
    func fetchWithPredicate(entityName: String, argumentArray: [String: NSObject])  -> [NSManagedObject]?  {

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
    
    func saveAccelerometerData(data: CMAccelerometerData){
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
}
