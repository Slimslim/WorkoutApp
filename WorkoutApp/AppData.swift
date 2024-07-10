//
//  AppData.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 7/10/24.
//

import Foundation

let usernames = ["Selim", "Yassin", "Kristi"]

struct WorkoutMovement: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let isWeighted: Bool
}

let workoutMovements: [WorkoutMovement] = [
    WorkoutMovement(name: "Back Squat", isWeighted: true),
    WorkoutMovement(name: "Air Squat", isWeighted: false),
    WorkoutMovement(name: "Bench Press", isWeighted: true),
    WorkoutMovement(name: "Burpee", isWeighted: false),
    WorkoutMovement(name: "Strict Pull-Up", isWeighted: false),
    WorkoutMovement(name: "Push-Up", isWeighted: false)
]
