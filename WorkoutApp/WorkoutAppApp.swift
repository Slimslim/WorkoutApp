//
//  WorkoutAppApp.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 6/25/24.
//

import SwiftUI
//import SwiftData
import RealmSwift

//let realmApp = RealmSwift.App(id: "workoutapp-fepvuis")

// Configure the Realm App with the new base URL
let configuration = AppConfiguration(
   baseURL: "https://services.cloud.mongodb.com", // You can customize base URL
   transport: nil, // Custom RLMNetworkTransportProtocol
   defaultRequestTimeoutMS: 30000
)
let realmApp = RealmSwift.App(id: "workoutapp-fepvuis", configuration: configuration)

@main
struct WorkoutAppApp: SwiftUI.App {
    // Inject AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var watchConnector = WatchConnector.shared
    
    var body: some Scene {
        WindowGroup {
//            MainTabView()
            ContentView()
                .environmentObject(watchConnector)
                .environmentObject(WorkoutStateManager.shared)
//            TestView()
        }
    }
}



//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        return true
//    }
//}
