//
//  WorkoutInfoModel.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 6/26/24.
//

import Foundation

struct WorkoutInformation: Codable {
    let date: Date
    let username: String
    let movement: String
    let rounds: Int
    let reps: Int
    let weight: Double
    
    init(date: Date, username: String, movement: String, rounds: Int, reps: Int, weight: Double) {
        self.date = date
        self.username = username
        self.movement = movement
        self.rounds = rounds
        self.reps = reps
        self.weight = weight
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

struct WorkoutMotionData: Codable {
    var accelerometerSnapshots: [AccelerometerSnapshot]
    var gyroscopeSnapshots: [GyroscopeSnapshot]

    init(accelerometerSnapshots: [AccelerometerSnapshot], gyroscopeSnapshots: [GyroscopeSnapshot]) {
        self.accelerometerSnapshots = accelerometerSnapshots
        self.gyroscopeSnapshots = gyroscopeSnapshots
    }
}


