//
//  WatchWourkoutAppApp.swift
//  WatchWourkoutApp Watch App
//
//  Created by Sélim Gawad on 6/25/24.
//

import SwiftUI
import SwiftData

@main
struct WorkoutAiAppWatchApp: App {
    
    @StateObject var phoneConnector = PhoneConnector()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
//                    PhoneConnector()
//                    WatchConnectivityManager.shared.initialize()
                }
        }
//        .modelContainer(for: WorkoutDataChunk.self)
    }
    
    init(){
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}

