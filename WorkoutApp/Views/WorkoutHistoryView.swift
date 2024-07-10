//
//  WorkoutHistoryView.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 6/26/24.
//

import SwiftUI
import SwiftData

struct WorkoutHistoryView: View {
//    @Query(sort: \WorkoutDataChunk.info.date) private var workouts:[WorkoutDataChunk]
//    @State private var workouts: [String] = ["Workout 1", "Workout 2", "Workout 3"]

    var body: some View {
        NavigationStack{
            List{
//                ForEach(workouts) { workout in
//                    NavigationLink{
//                        Text(workout.movement)
//                    } label: {
//                        HStack(spacing:10){
//                            VStack(alignment: .leading) {
//                                Text(workout.movement).font(.title2)
//                            }
//                        }
//                    }
//                }
                
            }
            .listStyle(.plain)
            .padding()
            .navigationTitle("Collected Data")
        }
    }
}

struct WorkoutHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutHistoryView()
    }
}

#Preview {
    WorkoutHistoryView()
//        .modelContainer(for: WorkoutDataChunk.self, inMemory: true)
}

