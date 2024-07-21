//
//  MainTabView.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 6/26/24.
//

import SwiftUI
import RealmSwift

struct MainTabView: View {
    
    let username:String
    
    // Initialize SharedWorkoutInfo to be used in all child views before saving it to database
    @StateObject private var sharedWorkoutInfo = SharedWorkoutInfo.shared
    
    
    var body: some View {
        if let realmUser = realmApp.currentUser{
            TabView {
                WorkoutFormView()
                    .tabItem {
                        Label("Workout", systemImage: "figure.walk")
                    }
                    .environmentObject(sharedWorkoutInfo) // Provide the environment object here
                
                //            ProductsView(username: username)
                WorkoutHistoryView(username: username)
                    .tabItem {
                        Label("History", systemImage: "list.bullet")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            .environment(\.realmConfiguration, realmUser.flexibleSyncConfiguration())
        } else {
            Text("Please log in")
        }
        
    }
}

//struct MainTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainTabView()
//    }
//}
