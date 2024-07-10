////
////  DataModelShared.swift
////  WorkoutApp
////
////  Created by Sélim Gawad on 6/25/24.
////
//
//import Foundation
//import CoreMotion
//import SwiftData
//
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
