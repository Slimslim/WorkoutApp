//
//  ContentView.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 6/25/24.
//

import SwiftUI
import WatchConnectivity
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var workoutMovement: String = ""
    @State private var sessionStarted = false
    @State private var showingAlert = false
    let session = WCSession.default
    
    var body: some View {
        VStack {
            TextField("Enter workout movement", text: $workoutMovement)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                startSession()
            }) {
                Text(sessionStarted ? "Stop Session" : "Start Session")
                    .padding()
                    .background(sessionStarted ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Session Started"), message: Text("Please go to your watch to start the session"), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }
    
    func startSession() {
        if sessionStarted {
            session.sendMessage(["action": "stop"], replyHandler: nil, errorHandler: nil)
            sessionStarted = false
        } else {
            session.sendMessage(["action": "start", "workoutMovement": workoutMovement], replyHandler: nil, errorHandler: nil)
            sessionStarted = true
            showingAlert = true
        }
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
