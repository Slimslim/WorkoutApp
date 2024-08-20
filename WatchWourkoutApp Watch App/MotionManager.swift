//
//  MotionManager.swift
//  WatchWourkoutApp Watch App
//
//  Created by Sélim Gawad on 6/25/24.
//

import Foundation
import HealthKit
import CoreMotion
import WatchConnectivity
import WatchKit
//import SwiftData


class MotionManager: NSObject, ObservableObject {
    
    let phoneConnector = PhoneConnector.shared
    let healthStore = HKHealthStore()
    
    @Published var isCollecting = false
    
    private var sensorManager = CMBatchedSensorManager()
    private var workoutSession: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?
    private var runtimeSession: WKExtendedRuntimeSession?
    
    var dataCount = 0
    let maxDataCount = 10
    
    // Properties to hold the collected data
    private var accelerometerSnapshots: [AccelerometerSnapshot] = []
    private var gyroscopeSnapshots: [GyroscopeSnapshot] = []
    
    /// Properties to hold workout information
//    @Published var workoutInfo: WorkoutInfoData?
//    @Published var sharedWorkoutInfo: SharedWorkoutInfo?
    @Published var sharedWorkoutInfo: SharedWorkoutInfo = .shared
    
//    // Properties for SwiftData
//    private var context: ModelContext?
//    func setContext(_ context: ModelContext) {
//            self.context = context
//        }
    
    func start(workoutType: HKWorkoutActivityType) {
        isCollecting = true
        print("Start with workoutType: \(workoutType)")
        startWorkoutSession(workoutType: workoutType)
        startDataCollection()
    }
    
    func stop() {
        stopDataCollection()
        stopWorkoutSession()
        // Save the data, encode it into a file and send it to the phone
        saveData()
        //phoneConnector.sendDataToPhone(data: SharedWorkoutInfo.shared)
        
        // Reinitialize sensor and clear the data after saving
        reinitializeSensorManager()
        clearMotionData()
    }
    
    private func startWorkoutSession(workoutType: HKWorkoutActivityType) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .outdoor
        
        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = workoutSession?.associatedWorkoutBuilder()
            builder?.dataSource = HKLiveWorkoutDataSource(
                healthStore: healthStore,
                workoutConfiguration: configuration
            )
        } catch {
            print("Error setting up workout session: \(error)")
            return
        }
        
        let startDate = Date()
        workoutSession?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { success, error in
            if let error = error {
                print("Error starting workout session: \(error.localizedDescription)")
            } else {
                print("Workout session started successfully")
            }
        }
        
//        // Request an extended runtime session
//        self.runtimeSession = WKExtendedRuntimeSession()
//        self.runtimeSession?.delegate = self
//        self.runtimeSession?.start()
    }
        
    private func stopWorkoutSession() {
        guard let workoutSession = workoutSession, let builder = builder else {
            print("No active workout session to stop")
            return
        }
        
//        //Invalidate the session to stop it without saving
//        workoutSession.end()
        
        workoutSession.stopActivity(with: Date())
        builder.endCollection(withEnd: Date()) { success, error in
            if let error = error {
                print("Error ending workout session: \(error.localizedDescription)")
            } else {
                print("Workout session ended successfully")
            }
        }
        self.workoutSession = nil
        self.builder = nil
    }
    
    func startDataCollection() {
        print("Start Data Collection Function Started")
        guard CMBatchedSensorManager.isAccelerometerSupported && CMBatchedSensorManager.isDeviceMotionSupported else {
            print("Sensors not supported")
            return
        }
        
        // Task for collecting accelerometer data
        Task {
            do {
                for try await dataArray in sensorManager.accelerometerUpdates(){
                    for data in dataArray{
                        if self.dataCount < self.maxDataCount{
                            let snapshot = AccelerometerSnapshot(
                                timestamp: data.timestamp,
                                accelerationX: data.acceleration.x,
                                accelerationY: data.acceleration.y,
                                accelerationZ: data.acceleration.z
                            )
                            accelerometerSnapshots.append(snapshot)
//                            print("Accelerometer data appended: \(snapshot)")
//                            print("Current Accelerometer Data: \(accelerometerSnapshots)")
                        }
                    }
                }
                
            } catch let error as NSError {
                print("Error collecting accelerometer data: \(error)")
            }
        }
        
        // Task for collecting gyroscopic data
        Task{
            do {
                for try await dataArray in sensorManager.deviceMotionUpdates(){
                    for data in dataArray{
                        let snapshot = GyroscopeSnapshot(
                            timestamp: data.timestamp,
                            rotationX: data.rotationRate.x,
                            rotationY: data.rotationRate.y,
                            rotationZ: data.rotationRate.z
                        )
                        gyroscopeSnapshots.append(snapshot)
                        //                            print("Gyroscope data appended: \(snapshot)")
                    }
                }
                
            } catch let error as NSError {
                print("Error collecting gyroscope data: \(error)")
            }
        }
    }
    
    func stopDataCollection() {
        sensorManager.stopAccelerometerUpdates()
        sensorManager.stopDeviceMotionUpdates()
//        //Added to fully stop and reset Sensor
//        accelerometerSnapshots.removeAll()
//        gyroscopeSnapshots.removeAll()
        
//        print("Current Accelerometer Data: \(accelerometerSnapshots)")
        isCollecting = false
    }
    
    func requestHKAuthorization() {
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]

        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
            HKObjectType.activitySummaryType()
        ]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            if success{
                print("HealthKit authorization granted")
            } else {
                if let error = error {
                    print("Error requesting authorization: \(error.localizedDescription)")
                } else {
                    print("HealthKit authorization failed without an error")
                }
            }
        }
    }
    
    /// Function to gather and save all the data in one object
    func saveData() {
        print("Saving data...")
//        print("Accelerometer data count: \(accelerometerSnapshots.count)")
//        print("Gyroscope data count: \(gyroscopeSnapshots.count)")
        
        // Ensure workoutData is initialized
        if sharedWorkoutInfo.workoutData == nil {
            sharedWorkoutInfo.workoutData = WorkoutMotionData(accelerometerSnapshots: [], gyroscopeSnapshots: [])
        }
        
        sharedWorkoutInfo.workoutData?.accelerometerSnapshots = self.accelerometerSnapshots
        sharedWorkoutInfo.workoutData?.gyroscopeSnapshots = self.gyroscopeSnapshots
        sharedWorkoutInfo.printWorkoutInfo()
        
        // Save workout data to file
        self.phoneConnector.saveWorkoutInfoToFile { fileURL in
            // Transfer the file to the phone
            self.phoneConnector.transferFileToPhone(fileURL: fileURL)
        }
        
    }
    
    func clearMotionData() {
        accelerometerSnapshots.removeAll()
        gyroscopeSnapshots.removeAll()
    }
    
    func reinitializeSensorManager() {
        sensorManager = CMBatchedSensorManager()
    }
    
}

extension MotionManager: WKExtendedRuntimeSessionDelegate {
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("Extended runtime session started")
    }

    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("Extended runtime session will expire")
        stop()
    }

    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        if let error = error {
            print("Extended runtime session invalidated with error: \(error.localizedDescription)")
        } else {
            print("Extended runtime session invalidated with reason: \(reason.rawValue)")
        }
        stop()
    }
}
