//
//  WorkoutHistoryView.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 6/26/24.
//

import SwiftUI
import SwiftData
import RealmSwift

struct WorkoutHistoryView: View {
    /// Fetching data and sort itby date created
    @ObservedResults(Workout.self, sortDescriptor: SortDescriptor(keyPath: "created", ascending: false)) var workouts
    @Environment(\.realm) var realm
    
    let username: String
    @State private var searchText = ""
    @State private var busy = false
    
    var body: some View {
        
        // filter list with search text
        let filteredWorkouts = workouts.where{ Workout in
            Workout.info.movement.contains(searchText, options: .caseInsensitive)
            ||
            Workout.username.contains(searchText, options: .caseInsensitive)
        }
        
        NavigationStack{
            if !busy {
                List {
                    ForEach(searchText.isEmpty ? workouts : filteredWorkouts) { workout in
                        HStack {
                            HStack {
                                let movement = workout.info?.movement ?? ""
                                let rounds = workout.info?.rounds ?? 0
                                let reps = workout.info?.reps ?? 0
                                
                                Text(movement)
                                Text("\(rounds) X \(reps)")
                                    .onAppear {
                                        print("Movement: \(movement), Rounds: \(rounds), Reps: \(reps)")
                                    }
                            }
                            Spacer()
                            Image(systemName: workout.isDataGood ? "checkmark" : "xmark")
                                .foregroundColor(workout.isDataGood ? .green : .red)
                                .font(.system(size: 15, weight: .semibold))
                                .padding(.trailing)
                        }
                    }
                }
                .searchable(text: $searchText)
                .listStyle(.plain)
                .padding()
                .navigationTitle("Collected Data")
            } else {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .background(Color.white.opacity(0.8))
            }
        }
        /// Subscribe and unsubscribe from databse when in the view
        .onAppear(perform: {
            MongoDbManager.shared.subscribe(realm: realm, busy: $busy)
        })
        .onDisappear(perform: {
            MongoDbManager.shared.unsubscribe(realm: realm, busy: $busy)
        })
    }
}

//struct WorkoutHistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutHistoryView()
//    }
//}
//
//#Preview {
//    WorkoutHistoryView()
////        .modelContainer(for: WorkoutDataChunk.self, inMemory: true)
//}

