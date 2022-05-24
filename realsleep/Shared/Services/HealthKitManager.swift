//
//  HealthDataManager.swift
//  realsleep
//
//  Created by Ar on 5/11/22.
//

import Foundation
import SwiftUI
import HealthKit
import CoreMotion


struct HealthKitManager {
    static var shared = HealthKitManager()
    private var healthStore = HKHealthStore()
    private var motionManager = CMMotionManager()
    let writeTypes: Set<HKSampleType> = [HKObjectType.workoutType()]
    let readTypes: Set = [HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                          HKObjectType.quantityType(forIdentifier: .stepCount)!]
    
    func performHealthDataAuthorization(authCompletionCallback: @escaping ( _ isSuccess: Bool, _ error: Error?) -> Void){
        healthStore.requestAuthorization(toShare: writeTypes, read: readTypes, completion: authCompletionCallback)
    }
    
    func getLatestSample(quantityType: HKQuantityTypeIdentifier ,resultsHandler: @escaping (HKSampleQuery, [HKSample]?, Error?) -> Void){
        guard let sampleType = HKSampleType.quantityType(forIdentifier: quantityType) else {
            fatalError("*** This method should never fail ***")
        }
        let sorting = NSSortDescriptor(key: "startDate", ascending: false)
        let query = HKSampleQuery(sampleType: sampleType, predicate: nil, limit: 1, sortDescriptors: [sorting],resultsHandler:  resultsHandler)
        healthStore.execute(query)
    }
    
    func getSamplesSinceTimeStamp(quantityType: HKQuantityTypeIdentifier, startTimeStamp: Date? = nil, resultsHandler: @escaping (HKSampleQuery, [HKSample]?, Error?) -> Void){
        guard let sampleType = HKSampleType.quantityType(forIdentifier: quantityType) else {
            fatalError("*** This method should never fail ***")
        }
        let today = Date()
        let startDate = startTimeStamp ?? Calendar.current.date(byAdding: .hour, value: -2, to: today)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: today, options: HKQueryOptions.strictEndDate)
            
        let sorting = NSSortDescriptor(key: "startDate", ascending: false)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sorting],resultsHandler:  resultsHandler)
        healthStore.execute(query)
    }
    
}
