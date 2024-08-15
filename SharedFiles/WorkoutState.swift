//
//  WorkoutState.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 8/14/24.
//

import Foundation


enum WorkoutState: Int, Codable {
    case waitingForPhone
    case workoutDefined
    case waitingForWatchStart
    case inProgress
    case completed
}


class WorkoutStateManager: ObservableObject {
    @Published var currentState: WorkoutState = .waitingForPhone
    
    // Singleton instance for shared access
    static let shared = WorkoutStateManager()
    
    private init() {}
    
    func transitionTo(_ newState: WorkoutState) {
        currentState = newState
        // Notify both Watch and Phone about the state change
        notifyDevices()
    }
    
    private func notifyDevices() {
        // Implement communication between Watch and Phone
        // e.g., using WatchConnectivity to sync the state
    }
}
