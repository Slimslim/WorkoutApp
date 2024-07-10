//
//  WorkoutAppApp.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 6/25/24.
//

import SwiftUI
import SwiftData

@main
struct WorkoutAppApp: App {
    // Inject AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var watchConnector = WatchConnector()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .onAppear {
//                    WatchConnector()
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}
