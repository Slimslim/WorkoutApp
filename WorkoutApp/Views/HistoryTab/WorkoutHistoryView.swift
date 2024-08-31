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
        
        // Computed property for grouping workouts by movement
        var groupedWorkouts: [String: [Workout]] {
            let workoutsToGroup = searchText.isEmpty ? workouts : filteredWorkouts
            return Dictionary(grouping: workoutsToGroup, by: { $0.info?.movement ?? "Unknown" })
        }
        
        NavigationStack{
            if !busy {
                List {
                    // Group workouts by movement name
                    ForEach(groupedWorkouts.keys.sorted(), id: \.self) { movement in
                        let workoutsForMovement = groupedWorkouts[movement] ?? []
                        let count = workoutsForMovement.count
                        
                        NavigationLink(destination: WorkoutDetailView(workouts: workoutsForMovement)) {
                            HStack {
                                Text("\(movement)") // Display movement name with count
                                    .font(.headline)
                                Spacer()
                                Text("\(count)")
                            }
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
            MongoDbManager.shared.subscribeToCoreMotionData(realm: realm, busy: $busy)
        })
        .onDisappear(perform: {
            MongoDbManager.shared.unsubscribe(realm: realm, busy: $busy)
            MongoDbManager.shared.unsubscribeFromCoreMotionData(realm: realm, busy: $busy) // Unsubscribe from CoreMotionData
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

