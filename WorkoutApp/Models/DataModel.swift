//
//  DataModelShared.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 6/25/24.
//

import Foundation
import CoreMotion
import SwiftData

@Model
class WorkoutDataChunk {
    var id: UUID
    var date: Date
    var createdBy: String
    var movement: String
    var rounds: Int
    var repetitions: Int
    var weight: Double
    var data: WorkoutMotionData?

    init(id: UUID, date: Date = Date.now, createdBy: String, movement: String, rounds: Int, repetitions: Int, weight: Double, data: WorkoutMotionData? = nil) {
        self.id = id
        self.date = date
        self.createdBy = createdBy
        self.movement = movement
        self.rounds = rounds
        self.repetitions = repetitions
        self.weight = weight
        self.data = data
    }
}

@Model
class AccelerometerSnapshot{
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

@Model
class GyroscopeSnapshot{
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

@Model
class WorkoutMotionData {
    var accelerometerSnapshots: [AccelerometerSnapshot]
    var gyroscopeSnapshots: [GyroscopeSnapshot]

    init(accelerometerSnapshots: [AccelerometerSnapshot], gyroscopeSnapshots: [GyroscopeSnapshot]) {
        self.accelerometerSnapshots = accelerometerSnapshots
        self.gyroscopeSnapshots = gyroscopeSnapshots
    }
}
