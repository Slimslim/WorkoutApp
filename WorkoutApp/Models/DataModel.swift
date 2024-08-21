//
//  DataModelShared.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 6/25/24.
//

import Foundation
import CoreMotion
import RealmSwift

// MARK: - Workout and Data Models

/// The `Workout` class represents the main workout entity.
/// It contains general information about the workout session, such as the user's name,
/// workout details, and a reference to the time-based batched data.
class Workout: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var created = Date()
    @Persisted var username: String
    @Persisted var notes: String?
    @Persisted var isDataGood: Bool
    @Persisted var info: WorkoutInfo?
    // Removed direct data embedding. Data is now stored in separate batch documents.
    
    /// Initializes a new `Workout` object.
    /// - Parameters:
    ///   - created: The date and time when the workout was created. Defaults to the current date and time.
    ///   - username: The name of the user who performed the workout.
    ///   - notes: Any additional notes related to the workout.
    ///   - isDataGood: A boolean indicating if the collected data is good for analysis.
    ///   - info: Detailed information about the workout.
    convenience init(created: Date? = nil, username: String, notes: String? = nil, isDataGood: Bool = false, info: WorkoutInfo? = nil) {
        self.init()
        if let created = created {
            self.created = created
        }
        self.username = username
        self.notes = notes
        self.isDataGood = isDataGood
        self.info = info
    }
}

/// The `WorkoutInfo` class holds details about the workout, such as the movement performed,
/// the number of rounds and reps, and the weight used. It also includes metadata like the start
/// and end times of the workout and the total number of data batches.
class WorkoutInfo: EmbeddedObject {
    @Persisted var movement: String
    @Persisted var rounds: Int
    @Persisted var reps: Int
    @Persisted var weight: Double?
    @Persisted var startTime: Date?  // Start time of the workout
    @Persisted var endTime: Date?  // End time of the workout
    @Persisted var numberOfBatches: Int?  // Total number of data batches
    @Persisted var version: Int  // Version number for the workout info data

    /// Initializes a new `WorkoutInfo` object.
    /// - Parameters:
    ///   - movement: The type of movement performed during the workout.
    ///   - rounds: The number of rounds completed.
    ///   - reps: The number of repetitions per round.
    ///   - weight: The weight used during the workout, if applicable.
    ///   - startTime: The start time of the workout.
    ///   - endTime: The end time of the workout.
    ///   - numberOfBatches: The total number of data batches generated during the workout.
    ///   - version: The version number for the workout info data.
    convenience init(movement: String, rounds: Int, reps: Int, weight: Double? = nil, startTime: Date? = nil, endTime: Date? = nil, numberOfBatches: Int? = nil, version: Int = 1) {
        self.init()
        self.movement = movement
        self.rounds = rounds
        self.reps = reps
        self.weight = weight
        self.startTime = startTime
        self.endTime = endTime
        self.numberOfBatches = numberOfBatches
        self.version = version
    }
}

/// The `CoreMotionData` class represents a single time-based batch of motion data.
/// It includes the start and end times of the batch, the capture rates for the accelerometer and gyroscope,
/// and lists of the accelerometer and gyroscope data snapshots.
class CoreMotionData: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var workoutId: ObjectId  // Link back to the Workout
    @Persisted var batchNumber: Int  // To identify the order of the batch
    @Persisted var startTime: Date
    @Persisted var endTime: Date
    @Persisted var accelerometerRate: Int  // Capture rate of accelerometer in Hz
    @Persisted var gyroscopeRate: Int  // Capture rate of gyroscope in Hz
    @Persisted var accelerometerSnapshots = List<AccelerometerData>()
    @Persisted var gyroscopeSnapshots = List<GyroscopeData>()

    /// Initializes a new `WorkoutDataBatch` object.
    /// - Parameters:
    ///   - workoutId: The identifier of the workout to which this batch belongs.
    ///   - batchNumber: The sequential number of this batch.
    ///   - startTime: The start time of this batch.
    ///   - endTime: The end time of this batch.
    ///   - accelerometerRate: The capture rate of the accelerometer in Hz.
    ///   - gyroscopeRate: The capture rate of the gyroscope in Hz.
    ///   - accelerometerSnapshots: The list of accelerometer data snapshots in this batch.
    ///   - gyroscopeSnapshots: The list of gyroscope data snapshots in this batch.
    convenience init(workoutId: ObjectId, batchNumber: Int, startTime: Date, endTime: Date, accelerometerRate: Int, gyroscopeRate: Int, accelerometerSnapshots: [AccelerometerData], gyroscopeSnapshots: [GyroscopeData]) {
        self.init()
        self.workoutId = workoutId
        self.batchNumber = batchNumber
        self.startTime = startTime
        self.endTime = endTime
        self.accelerometerRate = accelerometerRate
        self.gyroscopeRate = gyroscopeRate
        self.accelerometerSnapshots.append(objectsIn: accelerometerSnapshots)
        self.gyroscopeSnapshots.append(objectsIn: gyroscopeSnapshots)
    }
}

/// The `AccelerometerData` class represents a single snapshot of accelerometer data.
/// Each snapshot contains the timestamp and the acceleration values along the X, Y, and Z axes.
class AccelerometerData: EmbeddedObject {
    @Persisted var timestamp: TimeInterval
    @Persisted var accelerationX: Double
    @Persisted var accelerationY: Double
    @Persisted var accelerationZ: Double

    /// Initializes a new `AccelerometerData` object.
    /// - Parameters:
    ///   - timestamp: The time at which the data was captured.
    ///   - accelerationX: The acceleration along the X axis.
    ///   - accelerationY: The acceleration along the Y axis.
    ///   - accelerationZ: The acceleration along the Z axis.
    convenience init(timestamp: TimeInterval, accelerationX: Double, accelerationY: Double, accelerationZ: Double) {
        self.init()
        self.timestamp = timestamp
        self.accelerationX = accelerationX
        self.accelerationY = accelerationY
        self.accelerationZ = accelerationZ
    }
}

/// The `GyroscopeData` class represents a single snapshot of gyroscope data.
/// Each snapshot contains the timestamp and the rotation values along the X, Y, and Z axes.
class GyroscopeData: EmbeddedObject {
    @Persisted var timestamp: TimeInterval
    @Persisted var rotationX: Double
    @Persisted var rotationY: Double
    @Persisted var rotationZ: Double

    /// Initializes a new `GyroscopeData` object.
    /// - Parameters:
    ///   - timestamp: The time at which the data was captured.
    ///   - rotationX: The rotation rate around the X axis.
    ///   - rotationY: The rotation rate around the Y axis.
    ///   - rotationZ: The rotation rate around the Z axis.
    convenience init(timestamp: TimeInterval, rotationX: Double, rotationY: Double, rotationZ: Double) {
        self.init()
        self.timestamp = timestamp
        self.rotationX = rotationX
        self.rotationY = rotationY
        self.rotationZ = rotationZ
    }
}

// MARK: - Conversion Functions

/// Converts an array of `AccelerometerSnapshot` to an array of `AccelerometerData`.
extension Array where Element == AccelerometerSnapshot {
    func toAccelerometerData() -> [AccelerometerData] {
        return self.map { snapshot in
            AccelerometerData(
                timestamp: snapshot.timestamp,
                accelerationX: snapshot.accelerationX,
                accelerationY: snapshot.accelerationY,
                accelerationZ: snapshot.accelerationZ
            )
        }
    }
}

/// Converts an array of `GyroscopeSnapshot` to an array of `GyroscopeData`.
extension Array where Element == GyroscopeSnapshot {
    func toGyroscopeData() -> [GyroscopeData] {
        return self.map { snapshot in
            GyroscopeData(
                timestamp: snapshot.timestamp,
                rotationX: snapshot.rotationX,
                rotationY: snapshot.rotationY,
                rotationZ: snapshot.rotationZ
            )
        }
    }
}

//class Workout: Object, ObjectKeyIdentifiable{
//    @Persisted(primaryKey: true) var _id:ObjectId
//    @Persisted var created = Date()
//    @Persisted var username: String
//    @Persisted var notes: String?
//    @Persisted var isDataGood: Bool
//    @Persisted var info : WorkoutInfo?
//    @Persisted var data : WorkoutData?
//    
//    
//    convenience init(created: Date? = nil, username: String, notes: String? = nil, isDataGood: Bool = false, info: WorkoutInfo? = nil, data: WorkoutData? = nil){
//        self.init()
//        if let created = created {
//            self.created = created
//        }
//        self.username = username
//        self.notes = notes
//        self.isDataGood = isDataGood
//        self.info = info
//        self.data = data
//    }
//    
//}
//
//class WorkoutInfo: EmbeddedObject {
//    
//    @Persisted var movement: String
//    @Persisted var rounds: Int
//    @Persisted var reps: Int
//    @Persisted var weight: Double?
//    
//    convenience init( movement: String, rounds: Int, reps: Int, weight: Double? = nil) {
//        self.init()
//        self.movement = movement
//        self.rounds = rounds
//        self.reps = reps
//        self.weight = weight
//    }
//}
//
//class WorkoutData: EmbeddedObject {
//    @Persisted var accelerometerSnapshots = List <AccelerometerData>()
//    @Persisted var gyroscopeSnapshots = List <GyroscopeData>()
//    
//    convenience init(accelerometerSnapshots: [AccelerometerData], gyroscopeSnapshots: [GyroscopeData]) {
//        self.init()
//        self.accelerometerSnapshots.append(objectsIn: accelerometerSnapshots)
//        self.gyroscopeSnapshots.append(objectsIn: gyroscopeSnapshots)
//    }
//    
//}
//
//class AccelerometerData: EmbeddedObject {
//    @Persisted var timestamp: TimeInterval
//    @Persisted var accelerationX: Double
//    @Persisted var accelerationY: Double
//    @Persisted var accelerationZ: Double
//
//    convenience init(timestamp: TimeInterval, accelerationX: Double, accelerationY: Double, accelerationZ: Double) {
//        self.init()
//        self.timestamp = timestamp
//        self.accelerationX = accelerationX
//        self.accelerationY = accelerationY
//        self.accelerationZ = accelerationZ
//    }
//}
//
//class GyroscopeData: EmbeddedObject {
//    @Persisted var timestamp: TimeInterval
//    @Persisted var rotationX: Double
//    @Persisted var rotationY: Double
//    @Persisted var rotationZ: Double
//
//    convenience init(timestamp: TimeInterval, rotationX: Double, rotationY: Double, rotationZ: Double) {
//        self.init()
//        self.timestamp = timestamp
//        self.rotationX = rotationX
//        self.rotationY = rotationY
//        self.rotationZ = rotationZ
//    }
//}
