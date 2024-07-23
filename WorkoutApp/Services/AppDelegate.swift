//
//  AppDelegate.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 6/25/24.
//

import UIKit
import WatchConnectivity

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Services.shared.configureAudioSession()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Services.shared.applicationDidEnterBackground()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        Services.shared.applicationWillEnterForeground()
    }
}

