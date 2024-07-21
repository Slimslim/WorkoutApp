////
////  WorkoutViews.swift
////  WorkoutApp
////
////  Created by Sélim Gawad on 7/12/24.
////
//
//import SwiftUI
//import RealmSwift
//
//struct WorkoutsView: View {
//    @ObservedResults(Workout.self, sortDescriptor: SortDescriptor(keyPath: "_id", ascending: false)) var workouts
//    @Environment(\.realm) var realm
//    
//    let username: String
//    let workout: String
//    
//    /// State variable busy for insicreanous subscition fct
//    @State private var busy = false
//    
//    var body: some View {
//        ZStack{
//            VStack{
//                List{
//                    ForEach(workouts) { workout in
//                        Text(workout.info.movement)
//                    }
//                }
//                Spacer()
//            }
//            .padding()
//            if busy{
//                ProgressView()
//            }
//        }
//        .navigationBarTitle(workout, displayMode: .inline)
//    }
//    
//    private func subscribe(){
//        let lastYear = Date(timeIntervalSinceReferenceDate: Date().timeIntervalSinceReferenceDate.rounded() - (60 * 60 * 24 * 365))
//        let subscriptions = realm.subscriptions
//        if subscriptions.first(named: workout) == nil {
//            busy = true
//            subscriptions.update {
//                subscriptions.append(QuerySubscription<Workout>(name: workout) { workout in
//                    return workout == workout
//                })
//            } onComplete: { error in
//                if let error = error {
//                    print("Failed to subscribe for")
//                }
////                busy = false
//            }
//        }
//    }
//    
//    private func unsubscribe(){
//        let subscriptions = realm.subscriptions
//        subscriptions.update {
//            subscriptions.remove(named: workout)
//        } onComplete: { error in
//            if let error = error{
//                print("Failed to unsubscripe for...")
//            }
//        }
//    }
//    
//}
//
////#Preview {
////    WorkoutsView()
////}
