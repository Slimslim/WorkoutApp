//
//  WorkoutState.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 8/14/24.
//

import Foundation
import Combine


/// Workout app state
enum WorkoutState: Int, Codable {
    /// Waiting for Phone: The app is waiting for the user to define and start the workout on the iPhone.
    case waitingForPhone
    /// Workout Defined: The workout has been defined on the phone, and the app is now waiting for the user to start the workout on the Watch.
    case workoutDefined
    /// Waiting for Watch Start: The workout is ready, and the user needs to start it on the Watch.
    case waitingForWatchStart
    /// In Progress: The workout is actively in progress, and data is being collected on the Watch.
    case inProgress
    /// Waiting For Data: Waits for data to be received before moving to the Completed state.
    case waitingForData
    /// Completed: The workout is complete, and the app is preparing to display the summary and save the data.
    case completed
}


class WorkoutStateManager: ObservableObject {

    @Published var currentState: WorkoutState = .waitingForPhone
    @Published var isWorkoutCompleted: Bool = false
    @Published var isWorkoutInProgress: Bool = false
    
    // Singleton instance for shared access
    static let shared = WorkoutStateManager()
    
    private init() {}
    
    func transitionTo(_ newState: WorkoutState) {
        // Only transition if the state is actually changing
        guard currentState != newState else {
//            print("State is already \(newState), no need to transition.")
            return
        }
        
        print("Transitioning from \(currentState) to \(newState)")
        currentState = newState
        
        // Update the boolean property whenever the state changes
        isWorkoutCompleted = (newState == .completed)
        isWorkoutInProgress = (newState == .inProgress)
        
        notifyDevices()
    }
    
    private func notifyDevices() {
        #if os(iOS)
        // Notify the Watch from the iPhone
        WatchConnector.shared.sendWorkoutStateToWatch(currentState)
        #elseif os(watchOS)
        // Notify the iPhone from the Watch
        PhoneConnector.shared.sendWorkoutStateToPhone(currentState)
        #endif
    }
    
//    // Utility functions to check the current state
//    var isWorkoutCompleted: Bool {
//        return currentState == .completed
//    }
//    
//    var isWorkoutInProgress: Bool {
//        return currentState == .inProgress
//    }
    
}
