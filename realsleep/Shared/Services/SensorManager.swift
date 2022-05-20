//
//  SensorManager.swift
//  realsleep
//
//  Created by Ar on 5/14/22.
//

import Foundation
import SwiftUI
import HealthKit
import CoreMotion


struct SensorManager {
    static var shared = SensorManager()
    private var motionManager = CMMotionManager()
    
    func getCurrentAccelerometerReading() -> CMAccelerometerData? {
        motionManager.startAccelerometerUpdates()
        print("executing - read accelerometer data")
        if let accelerometerData = motionManager.accelerometerData{
            return accelerometerData;
        }
        else{
            print("no data - motion manager")
        }
        return nil;
    }
    
}
