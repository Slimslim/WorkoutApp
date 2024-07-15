//
//  DataModelShared.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 6/25/24.
//


import Foundation
import CoreMotion
import RealmSwift

class Workout: Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var _id:ObjectId
    @Persisted var created = Date()
    @Persisted var username: String
    @Persisted var notes: String?
    @Persisted var isDataGood: Bool
    @Persisted var info : WorkoutInfo?
    @Persisted var data : WorkoutData?
    
    
    convenience init(created: Date? = nil, username: String, notes: String? = nil, isDataGood: Bool = false, info: WorkoutInfo? = nil, data: WorkoutData? = nil){
        self.init()
        if let created = created {
            self.created = created
        }
        self.username = username
        self.notes = notes
        self.isDataGood = isDataGood
        self.info = info
        self.data = data
    }
    
}

class WorkoutInfo: EmbeddedObject {
    
    @Persisted var movement: String
    @Persisted var rounds: Int
    @Persisted var reps: Int
    @Persisted var weight: Double?
    
    convenience init( movement: String, rounds: Int, reps: Int, weight: Double? = nil) {
        self.init()
        self.movement = movement
        self.rounds = rounds
        self.reps = reps
        self.weight = weight
    }
}

class WorkoutData: EmbeddedObject {
    @Persisted var accelerometerSnapshots = List <AccelerometerData>()
    @Persisted var gyroscopeSnapshots = List <GyroscopeData>()
    
    convenience init(accelerometerSnapshots: [AccelerometerData], gyroscopeSnapshots: [GyroscopeData]) {
        self.init()
        self.accelerometerSnapshots.append(objectsIn: accelerometerSnapshots)
        self.gyroscopeSnapshots.append(objectsIn: gyroscopeSnapshots)
    }
    
}

class AccelerometerData: EmbeddedObject {
    @Persisted var timestamp: TimeInterval
    @Persisted var accelerationX: Double
    @Persisted var accelerationY: Double
    @Persisted var accelerationZ: Double

    convenience init(timestamp: TimeInterval, accelerationX: Double, accelerationY: Double, accelerationZ: Double) {
        self.init()
        self.timestamp = timestamp
        self.accelerationX = accelerationX
        self.accelerationY = accelerationY
        self.accelerationZ = accelerationZ
    }
}

class GyroscopeData: EmbeddedObject {
    @Persisted var timestamp: TimeInterval
    @Persisted var rotationX: Double
    @Persisted var rotationY: Double
    @Persisted var rotationZ: Double

    convenience init(timestamp: TimeInterval, rotationX: Double, rotationY: Double, rotationZ: Double) {
        self.init()
        self.timestamp = timestamp
        self.rotationX = rotationX
        self.rotationY = rotationY
        self.rotationZ = rotationZ
    }
}



//@Model
//class WorkoutDataChunk {
//    var id: UUID
//    var info: WorkoutInfoData
//    var data: WorkoutMotionData?
//
//    init(id: UUID, info: WorkoutInfoData, data: WorkoutMotionData? = nil) {
//        self.id = id
//        self.info = info
//        self.data = data
//    }
//    
//}
//
//@Model
//class WorkoutInfoData{
//    let date: Date
//    let username: String
//    let movement: String
//    let rounds: Int
//    let reps: Int
//    let weight: Double
//    
//    init(date: Date, username: String, movement: String, rounds: Int, reps: Int, weight: Double) {
//        self.date = date
//        self.username = username
//        self.movement = movement
//        self.rounds = rounds
//        self.reps = reps
//        self.weight = weight
//    }
//}
//
//@Model
//class AccelerometerSnapshot{
//    var timestamp: TimeInterval
//    var accelerationX: Double
//    var accelerationY: Double
//    var accelerationZ: Double
//
//    init(timestamp: TimeInterval, accelerationX: Double, accelerationY: Double, accelerationZ: Double) {
//        self.timestamp = timestamp
//        self.accelerationX = accelerationX
//        self.accelerationY = accelerationY
//        self.accelerationZ = accelerationZ
//    }
//}
//
//@Model
//class GyroscopeSnapshot{
//    var timestamp: TimeInterval
//    var rotationX: Double
//    var rotationY: Double
//    var rotationZ: Double
//
//    init(timestamp: TimeInterval, rotationX: Double, rotationY: Double, rotationZ: Double) {
//        self.timestamp = timestamp
//        self.rotationX = rotationX
//        self.rotationY = rotationY
//        self.rotationZ = rotationZ
//    }
//}
//
//@Model
//class WorkoutMotionData {
//    var accelerometerSnapshots: [AccelerometerSnapshot]
//    var gyroscopeSnapshots: [GyroscopeSnapshot]
//
//    init(accelerometerSnapshots: [AccelerometerSnapshot], gyroscopeSnapshots: [GyroscopeSnapshot]) {
//        self.accelerometerSnapshots = accelerometerSnapshots
//        self.gyroscopeSnapshots = gyroscopeSnapshots
//    }
//}
