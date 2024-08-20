//
//  ContentView.swift
//  WatchWourkoutApp Watch App
//
//  Created by Sélim Gawad on 6/25/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var phoneConnector: PhoneConnector
    @EnvironmentObject var stateManager: WorkoutStateManager
    //    @Environment(\.modelContext) private var context
    
    @StateObject private var sharedWorkoutInfo = SharedWorkoutInfo.shared
    @StateObject private var motionManager = MotionManager()
    
//    @StateObject private var stateManager = WorkoutStateManager.shared
    
    
    
    @State private var sessionStarted = false
    
    var body: some View {
        
        VStack {
            
            switch stateManager.currentState {
            case .waitingForPhone:
                Text("Start the workout on your phone")
            case .workoutDefined:
                Text(workoutInfoText)
                    .padding()
                Button(action: {
                    stateManager.transitionTo(.inProgress)
                    toggleSession()
                }) {
                    Text("Start Session")
                }
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(100)
            case .inProgress:
                Text(workoutInfoText)
                    .padding()
                Button(action: {
                    stateManager.transitionTo(.waitingForData)
                    toggleSession()
                }) {
                    Text("Stop Session")
                }
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(100)
            case .waitingForData:
                Text("Sending...")
            case .completed:
                Text("Workout completed")
                // Add any other necessary UI components
            case .waitingForWatchStart:
                // Provide an empty view or a placeholder
                EmptyView()
            }
        }
        .onAppear {
            motionManager.requestHKAuthorization()
        }
        
        
    }
    
    private var workoutInfoText: String {
        if let workoutInfo = sharedWorkoutInfo.workoutInfo {
            let weightText = workoutInfo.weight != nil ? "\(workoutInfo.weight!)lbs" : "N/A"
            return "\(workoutInfo.movement)\n\(workoutInfo.rounds) x \(workoutInfo.reps) @ \(weightText)lbs"
        } else {
            return "Receiving..."
        }
    }
    
    private func toggleSession() {
        if sessionStarted {
            motionManager.stop()
            //            phoneConnector.sendDataToPhone(message: "message from Watch")
            print("Workout has stopped")
        } else {
            motionManager.start(workoutType: .other)
            print("Workout has started")
        }
        sessionStarted.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PhoneConnector.shared)
    }
}
