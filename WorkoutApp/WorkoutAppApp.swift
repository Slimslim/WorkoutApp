//
//  WorkoutAppApp.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 6/25/24.
//

import SwiftUI
import SwiftData
import RealmSwift

let realmApp = RealmSwift.App(id: "workoutapp-fepvuis")

@main
struct WorkoutAppApp: SwiftUI.App {
    // Inject AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var watchConnector = WatchConnector()
    
    var body: some Scene {
        WindowGroup {
//            MainTabView()
            ContentView()
//            TestView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}
