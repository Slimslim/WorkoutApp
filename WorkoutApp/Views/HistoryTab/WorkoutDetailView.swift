//
//  WorkoutDetailView.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 8/26/24.
//

import SwiftUI

struct WorkoutDetailView: View {
    let workouts: [Workout] // The workouts to display for the selected movement
    
    var body: some View {
        List {
            ForEach(workouts) { workout in
                NavigationLink(destination: DataDetailView(workout: workout)) {
                    HStack {
                        let movement = workout.info?.movement ?? ""
                        let rounds = workout.info?.rounds ?? 0
                        let reps = workout.info?.reps ?? 0
                        
                        Text(movement)
                        Text("\(rounds) X \(reps)")
                        Spacer()
                        Image(systemName: workout.isDataGood ? "checkmark" : "xmark")
                            .foregroundColor(workout.isDataGood ? .green : .red)
                            .font(.system(size: 15, weight: .semibold))
                            .padding(.trailing)
                    }
                }
            }
        }
        .navigationTitle("\(workouts.first?.info?.movement ?? "Unknown Movement") collected")
        .listStyle(.plain)
    }
}
