//
//  SensorDataViewer.swift
//  realsleep
//
//  Created by Ar on 5/28/22.
//

import SwiftUI
import CoreMotion

struct SensorDataViewer: View {
    @State var accelerometerData: CMAccelerometerData = CMAccelerometerData();
    @State var dataString: String = "";
    @State var timer: Timer?
    private var sensorManager: SensorManager = SensorManager.shared
    var body: some View {
        VStack{
            Text(dataString)
        }.onAppear(perform: runOnAppear)
    }
    func runOnAppear(){
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            //refreshAccelerometerData()
            //todo - run the above in background
        })
        
    }
    func refreshAccelerometerData(){
        if let data = sensorManager.getCurrentAccelerometerReading(){
            self.accelerometerData = data;
            dataString = "Accelerometer Data: " + String(format: "x: %.2f", accelerometerData.acceleration.x) +
            String(format: " y: %.2f", accelerometerData.acceleration.y) +
            String(format: " z: %.2f", accelerometerData.acceleration.z)
        }
    }
}

struct SensorDataViewer_Previews: PreviewProvider {
    static var previews: some View {
        SensorDataViewer()
    }
}
