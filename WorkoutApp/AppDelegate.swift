//
//  AppDelegate.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 6/25/24.
//

import UIKit
import WatchConnectivity

//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    var window: UIWindow?
//    let watchConnectivityManager = WatchConnectivityManager()
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        NotificationCenter.default.addObserver(self, selector: #selector(handleWorkoutMessage(_:)), name: Notification.Name("WorkoutMessageReceived"), object: nil)
//        return true
//    }
//
//    @objc func handleWorkoutMessage(_ notification: Notification) {
//        if let message = notification.userInfo?["message"] as? String {
//            print("Workout message received: \(message)")
//            // Handle the received message as needed
//        }
//    }
//
//    // Other app delegate methods...
//}
