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
    
    init(accelerometerSnapshots: [AccelerometerSnapshot], gyroscopeSnapshots: [GyroscopeSnapshot], accelerometerRate: Int = 50, gyroscopeRate: Int = 25) {
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

    
    /// Batches the motion data based on calculated time intervals.
    /// The time interval is determined by the data collection rates of the accelerometer and gyroscope.
    /// - Parameters:
    ///   - targetEntriesPerBatch: The target number of entries per batch. Default is 10,000.
    /// - Returns: An array of smaller `WorkoutMotionData` batches.
    func batchByTimeInterval(targetEntriesPerBatch: Int = 10000) -> [WorkoutMotionData] {
        var batches = [WorkoutMotionData]()
        var currentBatchStartTime: TimeInterval? = nil
        var currentBatchAccelerometerSnapshots = [AccelerometerSnapshot]()
        var currentBatchGyroscopeSnapshots = [GyroscopeSnapshot]()
        
        // Calculate the batch duration based on the combined target entries
        let batchTimeInterval = calculateCombinedBatchDuration(targetEntriesPerBatch: targetEntriesPerBatch)
        
        // Iterate through both accelerometer and gyroscope snapshots
        var accelIndex = 0
        var gyroIndex = 0
        
        while accelIndex < accelerometerSnapshots.count || gyroIndex < gyroscopeSnapshots.count {
            let accelTimestamp = accelIndex < accelerometerSnapshots.count ? accelerometerSnapshots[accelIndex].timestamp : .infinity
            let gyroTimestamp = gyroIndex < gyroscopeSnapshots.count ? gyroscopeSnapshots[gyroIndex].timestamp : .infinity
            
            let currentTimestamp = min(accelTimestamp, gyroTimestamp)
            
            if let startTime = currentBatchStartTime {
                if currentTimestamp - startTime > batchTimeInterval {
                    // Create a new batch
                    let newBatch = WorkoutMotionData(
                        accelerometerSnapshots: currentBatchAccelerometerSnapshots,
                        gyroscopeSnapshots: currentBatchGyroscopeSnapshots,
                        accelerometerRate: accelerometerRate,
                        gyroscopeRate: gyroscopeRate
                    )
                    batches.append(newBatch)
                    
                    // Start a new batch
                    currentBatchStartTime = currentTimestamp
                    currentBatchAccelerometerSnapshots.removeAll()
                    currentBatchGyroscopeSnapshots.removeAll()
                }
            } else {
                // Start the first batch
                currentBatchStartTime = currentTimestamp
            }
            
            // Add the current snapshots to the appropriate batch
            if accelTimestamp == currentTimestamp {
                currentBatchAccelerometerSnapshots.append(accelerometerSnapshots[accelIndex])
                accelIndex += 1
            }
            
            if gyroTimestamp == currentTimestamp {
                currentBatchGyroscopeSnapshots.append(gyroscopeSnapshots[gyroIndex])
                gyroIndex += 1
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
    
    /// Returns the number of batches generated based on the dynamically calculated time interval.
    /// The time interval is determined by the data collection rates of the accelerometer and gyroscope.
    /// - Parameter targetEntriesPerBatch: The target number of entries per batch. Default is 10,000.
    /// - Returns: The number of batches generated.
    func getNumberOfBatches(targetEntriesPerBatch: Int = 10000) -> Int {
        return batchByTimeInterval(targetEntriesPerBatch: targetEntriesPerBatch).count
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


