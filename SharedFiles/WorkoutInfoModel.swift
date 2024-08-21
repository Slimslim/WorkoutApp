//
//  WorkoutInfoModel.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 6/26/24.
//

//

import Foundation

struct WorkoutInformation: Codable {
    var date: Date
    var username: String
    var movement: String
    var rounds: Int
    var reps: Int
    var weight: Double?
    var notes: String?
    var isDataGood: Bool
    
    init(date: Date, username: String, movement: String, rounds: Int, reps: Int, weight: Double?, notes : String?, isDataGood : Bool) {
        self.date = date
        self.username = username
        self.movement = movement
        self.rounds = rounds
        self.reps = reps
        self.weight = weight
        self.notes = notes
        self.isDataGood = isDataGood
    }
}

/// Represents the motion data captured during a workout, including accelerometer and gyroscope data.
struct WorkoutMotionData: Codable {
    var accelerometerSnapshots: [AccelerometerSnapshot]
    var gyroscopeSnapshots: [GyroscopeSnapshot]
    var accelerometerRate: Int  // The capture rate of accelerometer data in Hz
    var gyroscopeRate: Int  // The capture rate of gyroscope data in Hz
    
    init(accelerometerSnapshots: [AccelerometerSnapshot], gyroscopeSnapshots: [GyroscopeSnapshot], accelerometerRate: Int = -1, gyroscopeRate: Int = -1) {
        self.accelerometerSnapshots = accelerometerSnapshots
        self.gyroscopeSnapshots = gyroscopeSnapshots
        self.accelerometerRate = accelerometerRate
        self.gyroscopeRate = gyroscopeRate
    }
    
    /// Returns the start and end times based on the motion data snapshots.
    func getStartAndEndTime() -> (startTime: Date?, endTime: Date?) {
        // Determine the earliest and latest timestamps from the accelerometer and gyroscope data
        let allTimestamps = (accelerometerSnapshots.map { $0.timestamp } + gyroscopeSnapshots.map { $0.timestamp }).sorted()
        
        guard let firstTimestamp = allTimestamps.first, let lastTimestamp = allTimestamps.last else {
            return (nil, nil) // No data available
        }
        
        let startTime = Date(timeIntervalSince1970: firstTimestamp)
        let endTime = Date(timeIntervalSince1970: lastTimestamp)
        
        return (startTime, endTime)
    }

    
    /// Batches the motion data based on the data rates of the accelerometer and gyroscope.
    /// - Parameters:
    ///   - targetEntriesPerBatch: The target number of entries per batch. Default is 10,000.
    /// - Returns: An array of smaller `WorkoutMotionData` batches.
    func batchByDataRate(targetEntriesPerBatch: Int = 10000) -> [WorkoutMotionData] {
        var batches = [WorkoutMotionData]()
        var currentBatchAccelerometerSnapshots = [AccelerometerSnapshot]()
        var currentBatchGyroscopeSnapshots = [GyroscopeSnapshot]()
        
        // Calculate the ratio between accelerometer and gyroscope data rates
        let ratio = Double(accelerometerRate) / Double(gyroscopeRate)
        
        // Determine the number of accelerometer and gyroscope entries per batch
        let gyroEntriesPerBatch = targetEntriesPerBatch / Int(1 + ratio)
        let accelEntriesPerBatch = targetEntriesPerBatch - gyroEntriesPerBatch
        
        var accelCount = 0
        var gyroCount = 0
        
        for (accelIndex, accelSnapshot) in accelerometerSnapshots.enumerated() {
            currentBatchAccelerometerSnapshots.append(accelSnapshot)
            accelCount += 1
            
            // Only add a gyroscope snapshot if we haven't reached the gyroscope limit
            if gyroCount < gyroEntriesPerBatch, gyroCount < gyroscopeSnapshots.count {
                currentBatchGyroscopeSnapshots.append(gyroscopeSnapshots[gyroCount])
                gyroCount += 1
            }
            
            // Check if the batch limits are reached
            if accelCount >= accelEntriesPerBatch && gyroCount >= gyroEntriesPerBatch {
                // Create a new batch
                let newBatch = WorkoutMotionData(
                    accelerometerSnapshots: currentBatchAccelerometerSnapshots,
                    gyroscopeSnapshots: currentBatchGyroscopeSnapshots,
                    accelerometerRate: accelerometerRate,
                    gyroscopeRate: gyroscopeRate
                )
                batches.append(newBatch)
                
                // Reset for the next batch
                currentBatchAccelerometerSnapshots.removeAll()
                currentBatchGyroscopeSnapshots.removeAll()
                accelCount = 0
                gyroCount = 0
            }
        }
        
        // Handle the last batch
        if !currentBatchAccelerometerSnapshots.isEmpty || !currentBatchGyroscopeSnapshots.isEmpty {
            let finalBatch = WorkoutMotionData(
                accelerometerSnapshots: currentBatchAccelerometerSnapshots,
                gyroscopeSnapshots: currentBatchGyroscopeSnapshots,
                accelerometerRate: accelerometerRate,
                gyroscopeRate: gyroscopeRate
            )
            batches.append(finalBatch)
        }
        
        print("Total number of batches created: \(batches.count)")
        return batches
    }
    
    /// Calculates the appropriate batch duration based on the target number of combined entries from both accelerometer and gyroscope data.
    /// - Parameters:
    ///   - targetEntriesPerBatch: The target number of combined entries per batch. Default is 1000.
    /// - Returns: The calculated time interval for each batch.
    func calculateCombinedBatchDuration(targetEntriesPerBatch: Int = 10000) -> TimeInterval {
        // Calculate the combined rate (entries per second) for both sensors
        let combinedRate = Double(accelerometerRate + gyroscopeRate)
        
        // Calculate the time interval needed to achieve the target number of entries
        return Double(targetEntriesPerBatch) / combinedRate
    }
    
    /// Returns the number of batches generated based on the data rates of the accelerometer and gyroscope.
    /// The batch size is determined by the data rates and the target number of entries per batch.
    /// - Parameter targetEntriesPerBatch: The target number of entries per batch. Default is 10,000.
    /// - Returns: The number of batches generated.
    func getNumberOfBatches(targetEntriesPerBatch: Int = 10000) -> Int {
        return batchByDataRate(targetEntriesPerBatch: targetEntriesPerBatch).count
    }
}

struct AccelerometerSnapshot: Codable{
    var timestamp: TimeInterval
    var accelerationX: Double
    var accelerationY: Double
    var accelerationZ: Double
    
    init(timestamp: TimeInterval, accelerationX: Double, accelerationY: Double, accelerationZ: Double) {
        self.timestamp = timestamp
        self.accelerationX = accelerationX
        self.accelerationY = accelerationY
        self.accelerationZ = accelerationZ
    }
}

struct GyroscopeSnapshot: Codable{
    var timestamp: TimeInterval
    var rotationX: Double
    var rotationY: Double
    var rotationZ: Double
    
    init(timestamp: TimeInterval, rotationX: Double, rotationY: Double, rotationZ: Double) {
        self.timestamp = timestamp
        self.rotationX = rotationX
        self.rotationY = rotationY
        self.rotationZ = rotationZ
    }
}

//
//struct WorkoutMotionData: Codable {
//    var accelerometerSnapshots: [AccelerometerSnapshot]
//    var gyroscopeSnapshots: [GyroscopeSnapshot]
//
//    init(accelerometerSnapshots: [AccelerometerSnapshot], gyroscopeSnapshots: [GyroscopeSnapshot]) {
//        self.accelerometerSnapshots = accelerometerSnapshots
//        self.gyroscopeSnapshots = gyroscopeSnapshots
//    }
//}


