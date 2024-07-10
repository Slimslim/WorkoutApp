//
//  MainTabView.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 6/26/24.
//

import SwiftUI

struct MainTabView: View {
    
    // Initialize SharedWorkoutInfo to be used in all child views before saving it to database
    @StateObject private var sharedWorkoutInfo = SharedWorkoutInfo.shared
    
    
    var body: some View {
        TabView {
            WorkoutFormView()
                .tabItem {
                    Label("Workout", systemImage: "figure.walk")
                }
                .environmentObject(sharedWorkoutInfo) // Provide the environment object here

            WorkoutHistoryView()
                .tabItem {
                    Label("History", systemImage: "list.bullet")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
