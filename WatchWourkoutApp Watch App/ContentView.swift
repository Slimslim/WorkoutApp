//
//  ContentView.swift
//  WatchWourkoutApp Watch App
//
//  Created by Sélim Gawad on 6/25/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var sharedWorkoutInfo = SharedWorkoutInfo.shared
    @StateObject var phoneConnector = PhoneConnector()
    @StateObject private var motionManager = MotionManager()
    @State private var sessionStarted = false
    @Environment(\.modelContext) private var context
    
    

    var body: some View {
        VStack {
            Text(workoutInfoText)
                .padding()
            
            if workoutInfoText != "Start the workout on your phone" {
                Button(action: {
                    toggleSession()
                }) {
                    Text(sessionStarted ? "Stop Session" : "Start Session")
                }
                .foregroundColor(.white)
                .background(sessionStarted ? Color.red : Color.green)
                .cornerRadius(100)
            }
        }
        .onAppear {
            motionManager.setContext(context)
            motionManager.requestHKAuthorization()
            // Any additional setup if needed
        }
        
        
    }
    
    private var workoutInfoText: String {
        if let workoutInfo = sharedWorkoutInfo.workoutInfo {
            let weightText = workoutInfo.weight != nil ? "\(workoutInfo.weight!)lbs" : "N/A"
            return "\(workoutInfo.movement)\n\(workoutInfo.rounds) x \(workoutInfo.reps) @ \(weightText)lbs"
        } else {
            return "Start the workout on your phone"
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
    }
}


#Preview {
    ContentView()
}
