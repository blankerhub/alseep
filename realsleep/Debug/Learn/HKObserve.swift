//
//  HKObserve.swift
//  realsleep
//
//  Created by Ar on 5/9/22.
//
import SwiftUI
import HealthKit
import CoreMotion
import BackgroundTasks

struct HKObserve: View {
    private var healthStore = HKHealthStore()
    private var motionManager = CMMotionManager()
    private var notifier = Notifier()
    //@State var timer = Timer()
    let heartRateQuantity = HKUnit(from: "count/min")
    
    @State var value: Double = 0
    @State var status = "nothing yet"
    @State var isButtonOn = false
    
    var body: some View {
        ScrollView{
            VStack{
                Button(action: onButtonClicked){
                    Image(isButtonOn ? "power-on" : "power-off")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                Text("\(value)")
                Text(status)
            }
        }.onAppear(perform: testHealthKit)
    }
    
    
    func onButtonClicked(){
        self.isButtonOn.toggle()
        //readData()
        //observeStepCount()
        onserveHeartRate()
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
        let readTypes: Set = [HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                              HKObjectType.quantityType(forIdentifier: .stepCount)!]
        healthStore.requestAuthorization(toShare: sampleTypes, read: readTypes, completion: onAuthCompletion)
    }
    
    func onAuthCompletion(isSuccess: Bool, error: Error?){
        if isSuccess{ self.status = "Successfully obtained permissions for health data"}
    }
    func onserveHeartRate(){
        status += "\n\n" + "starting observe heart rate"
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            // This should never fail when using a defined constant.
            fatalError("*** Unable to get the step count type ***")
        }
        let query = HKObserverQuery(sampleType: heartRateType, predicate: nil) { (query, completionHandler, errorOrNil) in
            
            if let error = errorOrNil {
                // Properly handle the error.
                return
            }
            status += "\n\n" + "heart rate changed"
            notifier.triggerDebugNotification(message: "heart rate changed")
            // Take whatever steps are necessary to update your app.
            // This often involves executing other queries to access the new data.
            
            // If you have subscribed for background updates you must call the completion handler here.
            //completionHandler()
        }
        
        healthStore.execute(query)
        Task{
            await try? healthStore.enableBackgroundDelivery(for: heartRateType, frequency: .immediate)
        }
        //healthStore.enableBackgroundDelivery(type, frequency: .Immediate) { (success: Bool, error: NSError?) in
//                        debugPrint("enableBackgroundDeliveryForType handler called for \(type) - success: \(success), error: \(error)")
//                    }
    }
    func observeStepCount(){
        status += "\n\n" + "starting observe step count"
        notifier.triggerDebugNotification(message: "starting observe step count")
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            // This should never fail when using a defined constant.
            fatalError("*** Unable to get the step count type ***")
        }
        let query = HKObserverQuery(sampleType: stepCountType, predicate: nil) { (query, completionHandler, errorOrNil) in
            
            if let error = errorOrNil {
                // Properly handle the error.
                return
            }
            status += "\n\n" + "step count changed"
            notifier.triggerDebugNotification(message: "step count changed")
            // Take whatever steps are necessary to update your app.
            // This often involves executing other queries to access the new data.
            
            // If you have subscribed for background updates you must call the completion handler here.
            //completionHandler()
        }
        
        healthStore.execute(query)
        Task{
            await try? healthStore.enableBackgroundDelivery(for: stepCountType, frequency: .immediate)
        }
        //healthStore.enableBackgroundDelivery(type, frequency: .Immediate) { (success: Bool, error: NSError?) in
//                        debugPrint("enableBackgroundDeliveryForType handler called for \(type) - success: \(success), error: \(error)")
//                    }
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


struct HKObserve_Previews: PreviewProvider {
    static var previews: some View {
        HKObserve()
    }
}
