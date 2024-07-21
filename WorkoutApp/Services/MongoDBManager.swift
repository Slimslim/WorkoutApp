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
    
    func subscribe(realm: Realm, busy: Binding<Bool>) {
        let subscriptions = realm.subscriptions
        if subscriptions.first(named: "allWorkouts") == nil {
            DispatchQueue.main.async {
                busy.wrappedValue = true
            }
            subscriptions.update {
                subscriptions.append(QuerySubscription<Workout>(name: "allWorkouts"))
            } onComplete: { error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Failed to subscribe for all workouts: \(error.localizedDescription)")
                    } else {
                        print("Successfully subscribed to all workouts")
                    }
                    busy.wrappedValue = false
                }
            }
        } else {
            print("Already subscribed to all workouts")
        }
    }
    
    func unsubscribe(realm: Realm, busy: Binding<Bool>) {
        let subscriptions = realm.subscriptions
        DispatchQueue.main.async {
            busy.wrappedValue = true
        }
        subscriptions.update {
            subscriptions.remove(named: "allWorkouts")
        } onComplete: { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Failed to unsubscribe from all workouts: \(error.localizedDescription)")
                } else {
                    print("Successfully unsubscribed from all workouts")
                }
                busy.wrappedValue = false
            }
        }
    }
}

