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
    @State private var busy = false
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(workouts) { workout in
                    HStack{
                        
                        HStack{
                            Text(workout.info?.movement ?? "")
                            Text("\(workout.info?.rounds ?? 0) X \(workout.info?.reps ?? 0)")
                        }
                        Spacer()
                        Image(systemName: workout.isDataGood == true ? "checkmark" : "xmark")
                            .foregroundColor(workout.isDataGood == true ? .green : .red)
                            .font(.system(size: 15, weight: .semibold))
                            .padding(.trailing)
                    }
                    
                }
            }
            .listStyle(.plain)
            .padding()
            .navigationTitle("Collected Data")
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

