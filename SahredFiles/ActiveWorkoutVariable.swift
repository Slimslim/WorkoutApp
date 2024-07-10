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

    private init() {} // Prevents others from using the default '()' initializer for this class.
    
    func reset() {
        DispatchQueue.main.async {
            self.workoutId = nil
            self.workoutInfo = nil
            self.workoutData = nil
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
            print("Weight: \(info.weight)")
        } else {
            print("No workout info available.")
        }
        
        if let data = workoutData {
            print("Accelerometer Snapshots: \(data.accelerometerSnapshots)")
            print("Gyroscope Snapshots: \(data.gyroscopeSnapshots)")
        } else {
            print("No motion data available.")
        }
    }
}
