//
//  MongoDBManager.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 7/15/24.
//

import Foundation
import RealmSwift
import SwiftUI

/// A singleton class that manages Realm subscriptions for the WorkoutApp.
class MongoDbManager {
    
    /// Shared instance of `MongoDbManager` for global access.
    static let shared = MongoDbManager()
    
    /// Private initializer to enforce the singleton pattern.
    private init() {}
    
    /// Subscribes to the "allWorkouts" query in Realm.
    ///
    /// This method checks if a subscription for all workouts already exists.
    /// If not, it creates the subscription and marks the `busy` binding as `true` during the operation.
    ///
    /// - Parameters:
    ///   - realm: The `Realm` instance used to manage the database.
    ///   - busy: A `Binding<Bool>` that indicates whether the operation is in progress.
    func subscribe(realm: Realm, busy: Binding<Bool>) {
        let subscriptions = realm.subscriptions
        
        // Check if the "allWorkouts" subscription already exists
        if subscriptions.first(named: "allWorkouts") == nil {
            // Set busy to true on the main thread to indicate that the operation is in progress
            DispatchQueue.main.async {
                busy.wrappedValue = true
            }
            // Add a subscription to all workouts and handle completion
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
    
    /// Subscribes to the "allCoreMotionData" query in Realm.
    ///
    /// This method checks if a subscription for all `CoreMotionData` already exists.
    /// If not, it creates the subscription and marks the `busy` binding as `true` during the operation.
    ///
    /// - Parameters:
    ///   - realm: The `Realm` instance used to manage the database.
    ///   - busy: A `Binding<Bool>` that indicates whether the operation is in progress.
    func subscribeToCoreMotionData(realm: Realm, busy: Binding<Bool>) {
        let subscriptions = realm.subscriptions
        
        // Set busy to true on the main thread to indicate that the operation is in progress
        DispatchQueue.main.async {
            busy.wrappedValue = true
        }
        
        // Add a subscription to all CoreMotionData and handle completion
        subscriptions.update {
            if subscriptions.first(named: "allCoreMotionData") == nil {
                subscriptions.append(QuerySubscription<CoreMotionData>(name: "allCoreMotionData"))
            }
        } onComplete: { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Failed to subscribe to CoreMotionData: \(error.localizedDescription)")
                } else {
                    print("Successfully subscribed to CoreMotionData")
                }
                // Set busy to false on completion
                busy.wrappedValue = false
            }
        }
    }
    
    /// Unsubscribes from the "allWorkouts" query in Realm.
    ///
    /// This method removes the "allWorkouts" subscription and marks the `busy` binding as `true` during the operation.
    ///
    /// - Parameters:
    ///   - realm: The `Realm` instance used to manage the database.
    ///   - busy: A `Binding<Bool>` that indicates whether the operation is in progress.
    func unsubscribe(realm: Realm, busy: Binding<Bool>) {
        let subscriptions = realm.subscriptions
        
        // Set busy to true on the main thread to indicate that the operation is in progress
        DispatchQueue.main.async {
            busy.wrappedValue = true
        }
        
        // Remove the "allWorkouts" subscription and handle completion
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
                busy.wrappedValue = false
            }
        }
    }
    
    /// Unsubscribes from the "allCoreMotionData" query in Realm.
    ///
    /// This method removes the subscription for all `CoreMotionData` objects from the Realm database.
    /// The `busy` binding is used to indicate whether the operation is in progress, allowing the UI to reflect
    /// this state if needed.
    ///
    /// - Parameters:
    ///   - realm: The `Realm` instance used to manage the database.
    ///   - busy: A `Binding<Bool>` that indicates whether the operation is in progress. This is typically used to update UI elements, like showing a loading spinner.
    func unsubscribeFromCoreMotionData(realm: Realm, busy: Binding<Bool>) {
        let subscriptions = realm.subscriptions
        
        // Set busy to true on the main thread to indicate that the operation is in progress
        DispatchQueue.main.async {
            busy.wrappedValue = true
        }
        
        // Update the Realm subscriptions by removing the "allCoreMotionData" subscription
        subscriptions.update {
            subscriptions.remove(named: "allCoreMotionData")
        } onComplete: { error in
            // Handle the completion of the unsubscription on the main thread
            DispatchQueue.main.async {
                if let error = error {
                    print("Failed to unsubscribe from CoreMotionData: \(error.localizedDescription)")
                } else {
                    print("Successfully unsubscribed from CoreMotionData")
                }
                // Set busy to false on completion to indicate that the operation has finished
                busy.wrappedValue = false
            }
        }
    }
}


