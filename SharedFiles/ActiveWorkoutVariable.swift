//
//  ActiveWorkoutVariable.swift
//  WatchWourkoutApp Watch App
//
//  Created by Sélim Gawad on 7/1/24.
//

import Foundation
import Combine

class SharedWorkoutInfo: ObservableObject, Codable {
    static let shared = SharedWorkoutInfo()
    
    @Published var workoutId: UUID?
    @Published var workoutInfo: WorkoutInformation?
    @Published var workoutData: WorkoutMotionData?

    private init() {
        // Initialize with empty data
        self.workoutData = WorkoutMotionData(accelerometerSnapshots: [], gyroscopeSnapshots: [])
    } // Prevents others from using the default '()' initializer for this class.
    
    func reset() {
        DispatchQueue.main.async {
            self.workoutId = nil
            self.workoutInfo = WorkoutInformation(
                date: Date(),
                username: "",
                movement: "Back Squat", // Set to the first valid movement
                rounds: 0,
                reps: 0,
                weight: nil,
                notes: "",
                isDataGood: false
            )
            // Initialize with empty data
            self.workoutData = WorkoutMotionData(accelerometerSnapshots: [], gyroscopeSnapshots: [])
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case workoutId, workoutInfo, workoutData
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        workoutId = try container.decode(UUID?.self, forKey: .workoutId)
        workoutInfo = try container.decode(WorkoutInformation?.self, forKey: .workoutInfo)
        workoutData = try container.decode(WorkoutMotionData?.self, forKey: .workoutData)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(workoutId, forKey: .workoutId)
        try container.encode(workoutInfo, forKey: .workoutInfo)
        try container.encode(workoutData, forKey: .workoutData)
    }
    
    func printWorkoutInfo() {
        if let id = workoutId, let info = workoutInfo {
            print("Workout ID: \(id)")
            print("Date: \(String(describing: info.date))")
            print("Username: \(info.username)")
            print("Movement: \(info.movement)")
            print("Rounds: \(info.rounds)")
            print("Reps: \(info.reps)")
            if let weight = info.weight {
                print("Weight: \(weight)")
            } else {
                print("Weight: N/A")
            }
        } else {
            print("No workout info available.")
        }
        
        if let data = workoutData {
            print("Accelerometer Snapshots count: \(data.accelerometerSnapshots.count)")
            print("Gyroscope Snapshots count: \(data.gyroscopeSnapshots.count)")
        } else {
            print("No motion data available.")
        }
    }
}

extension SharedWorkoutInfo {
    static var mock: SharedWorkoutInfo {
        let sharedWorkoutInfo = SharedWorkoutInfo()
        sharedWorkoutInfo.workoutId = UUID()
        sharedWorkoutInfo.workoutInfo = WorkoutInformation(
            date: Date(),
            username: "Selim",
            movement: "Front Squat",
            rounds: 3,
            reps: 10,
            weight: 135.0,
            notes: "Workout was smooth, no issues. Tried to have a 2 min rest between rounds",
            isDataGood: true
        )
        
        let mockAccelerometerData: [AccelerometerSnapshot] = [
            AccelerometerSnapshot(timestamp: Date().timeIntervalSince1970, accelerationX: 0.1, accelerationY: 0.2, accelerationZ: 0.3), AccelerometerSnapshot(timestamp: Date().addingTimeInterval(1).timeIntervalSince1970, accelerationX: 0.2, accelerationY: 0.3, accelerationZ: 0.4),
            AccelerometerSnapshot(timestamp: Date().addingTimeInterval(2).timeIntervalSince1970, accelerationX: 0.3, accelerationY: 0.4, accelerationZ: 0.5),
            // Add more mock data as needed
        ]
        
        sharedWorkoutInfo.workoutData = WorkoutMotionData(
            accelerometerSnapshots: mockAccelerometerData,
            gyroscopeSnapshots: []
        )
        return sharedWorkoutInfo
    }
}
