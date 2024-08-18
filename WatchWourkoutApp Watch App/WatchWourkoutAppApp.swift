//
//  WatchWourkoutAppApp.swift
//  WatchWourkoutApp Watch App
//
//  Created by Sélim Gawad on 6/25/24.
//

import SwiftUI
//import SwiftData

@main
struct WorkoutAiAppWatchApp: App {
    
    @StateObject var phoneConnector = PhoneConnector.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(phoneConnector)
                .environmentObject(WorkoutStateManager.shared)
                .onAppear {
                }
        }
    }
}

