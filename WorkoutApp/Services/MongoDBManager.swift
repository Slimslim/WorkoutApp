//
//  MongoDBManager.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 7/15/24.
//

import Foundation
import RealmSwift
import SwiftUI

class MongoDbManager {
    
    static let shared = MongoDbManager()
    
    private init() {}
    
    // Function to subscribe to "allWorkouts"
    func subscribe(realm: Realm, busy: Binding<Bool>) {
        let subscriptions = realm.subscriptions
        // Check if subscription already exists
        if subscriptions.first(named: "allWorkouts") == nil {
            // Set busy to true on the main thread
            DispatchQueue.main.async {
                busy.wrappedValue = true
            }
            // Add subscription and handle completion
            subscriptions.update {
                subscriptions.append(QuerySubscription<Workout>(name: "allWorkouts"))
            } onComplete: { error in
                // Handle subscription completion on the main thread
                DispatchQueue.main.async {
                    if let error = error {
                        print("Failed to subscribe for all workouts: \(error.localizedDescription)")
                    } else {
                        print("Successfully subscribed to all workouts")
                    }
                    // Set busy to false on completion
                    busy.wrappedValue = false
                }
            }
        } else {
            print("Already subscribed to all workouts")
        }
    }
    
    // Function to unsubscribe from "allWorkouts"
    func unsubscribe(realm: Realm, busy: Binding<Bool>) {
        let subscriptions = realm.subscriptions
        // Set busy to true on the main thread
        DispatchQueue.main.async {
            busy.wrappedValue = true
        }
        // Remove subscription and handle completion
        subscriptions.update {
            subscriptions.remove(named: "allWorkouts")
        } onComplete: { error in
            // Handle unsubscription completion on the main thread
            DispatchQueue.main.async {
                if let error = error {
                    print("Failed to unsubscribe from all workouts: \(error.localizedDescription)")
                } else {
                    print("Successfully unsubscribed from all workouts")
                }
                // Set busy to false on completion
                DispatchQueue.main.async {
                    busy.wrappedValue = false
                }
            }
        }
    }
}


