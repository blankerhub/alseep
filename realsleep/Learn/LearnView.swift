//
//  LearnView.swift
//  realsleep
//
//  Created by Ar on 5/3/22.
//

import SwiftUI
import HealthKit
import CoreMotion
import BackgroundTasks

struct LearnView: View {
    private var healthStore = HKHealthStore()
    private var motionManager = CMMotionManager()
    
    //@State var timer = Timer()
    let heartRateQuantity = HKUnit(from: "count/min")
    
    @State var value: Double = 0
    @State var status = "nothing yet"
    @State var isButtonOn = false
    
    var body: some View {
        ScrollView{
            CoreData()
            VStack{
                Button(action: onButtonClicked){
                    Image(isButtonOn ? "power-on" : "power-off")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                Text("\(value)")
                Text(status)
            }
        }
    }
    
    
    func onButtonClicked(){
        self.isButtonOn.toggle()
        //testHealthKit()
        testCoreData()
    }
    
    func testCoreData(){
        motionManager.startAccelerometerUpdates()
        if let accelerometerData = motionManager.accelerometerData{
            let timestamp = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd mm:ss"
            let accelerometerData = "Accelerometer Data: " + String(format: "x: %.2f", accelerometerData.acceleration.x) +
            String(format: " y: %.2f", accelerometerData.acceleration.y) +
            String(format: " z: %.2f", accelerometerData.acceleration.z)
            status += "\n\n" + dateFormatter.string(from: timestamp) + "\n" + accelerometerData;
        }
    }
    
    func testHealthKit(){
        let sampleTypes: Set<HKSampleType> = [HKObjectType.workoutType()]
        let readTypes: Set = [HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!]
        healthStore.requestAuthorization(toShare: sampleTypes, read: readTypes, completion: onAuthCompletion)
        readData()
    }
    
    func onAuthCompletion(isSuccess: Bool, error: Error?){
        if isSuccess{ self.status = "Successfully obtained permissions for health data"}
    }
    func readData(){
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned) else {
            fatalError("*** This method should never fail ***")
        }
        let sorting = NSSortDescriptor(key: "startDate", ascending: false)
        let query = HKSampleQuery(sampleType: sampleType, predicate: nil, limit: 1, sortDescriptors: [sorting]) {
            query, results, error in
            
            guard let samples = results as? [HKQuantitySample] else {
                // Handle any errors here.
                return
            }
            
            for sample in samples {
                value = sample.quantity.doubleValue(for: HKUnit.kilocalorie())
            }
            
            // The results come back on an anonymous background queue.
            // Dispatch to the main queue before modifying the UI.
            
            DispatchQueue.main.async {
                // Update the UI here.
            }
        }
        
        healthStore.execute(query)
        
    }
    
    func registerBackgroundTasks(){
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.realsleeptimer.main", using: nil) { task in
            self.refresh(task: task as! BGProcessingTask)
        }
        scheduleAppRefresh()
    }
    func refresh(task: BGProcessingTask){
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            testCoreData()
        })
        
    }
    
    func scheduleAppRefresh() {
        let request = BGProcessingTaskRequest(identifier: "com.realsleeptimer.main")
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView()
    }
}
