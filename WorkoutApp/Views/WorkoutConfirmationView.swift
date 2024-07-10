//
//  WorkoutConfirmationView.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 7/3/24.
//

import Foundation
import SwiftUI

struct WorkoutConfirmationView: View {
    
    // Shared workout information
    @EnvironmentObject var sharedWorkoutInfo: SharedWorkoutInfo
    
    // Computed property to get the selected movement
    var selectedMovement: WorkoutMovement? {
        guard let movementName = sharedWorkoutInfo.workoutInfo?.movement else {
            return nil
        }
        return workoutMovements.first { $0.name == movementName }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Information")) {
                    HStack{
                        Text("Username: ")
                        TextField("Username", text: Binding(
                            get: { sharedWorkoutInfo.workoutInfo?.username ?? "" },
                            set: { sharedWorkoutInfo.workoutInfo?.username = $0 }
                        ))
                    }
                    
                }
                
                Section(header: Text("Workout Details")) {
                    
                    Picker("Movement: ", selection: Binding(
                        get: { sharedWorkoutInfo.workoutInfo?.movement ?? "" },
                        set: { sharedWorkoutInfo.workoutInfo?.movement = $0 }
                    )) {
                        ForEach(workoutMovements, id: \.name) { movement in
                            Text(movement.name).tag(movement.name)
                        }
                    }
                    Stepper("Rounds: \(sharedWorkoutInfo.workoutInfo?.rounds ?? 0)", value: Binding(
                        get: { sharedWorkoutInfo.workoutInfo?.rounds ?? 0 },
                        set: { sharedWorkoutInfo.workoutInfo?.rounds = $0 }
                    ))
                    Stepper("Reps: \(sharedWorkoutInfo.workoutInfo?.reps ?? 0)", value: Binding(
                        get: { sharedWorkoutInfo.workoutInfo?.reps ?? 0 },
                        set: { sharedWorkoutInfo.workoutInfo?.reps = $0 }
                    ))
                    if selectedMovement?.isWeighted == true{
                        HStack{
                            Text("Weight: ")
                            TextField("Weight", value: Binding(
                                get: { sharedWorkoutInfo.workoutInfo?.weight ?? 0.0 },
                                set: { sharedWorkoutInfo.workoutInfo?.weight = $0 }
                            ), formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            Text("lbs")
                        }
                    }
                    
                    
                }
                
                Section(header: Text("Data collected")) {
                    HStack {
                        Text("Accelerometer Data")
                        Spacer()
                        Image(systemName: sharedWorkoutInfo.workoutData?.accelerometerSnapshots.isEmpty == false ? "checkmark" : "xmark")
                            .foregroundColor(sharedWorkoutInfo.workoutData?.accelerometerSnapshots.isEmpty == false ? .green : .red)
                            .font(.system(size: 24, weight: .bold))
                            .padding(.trailing)
                        
                    }
                    
                    HStack {
                        Text("Gyroscope Data")
                        Spacer()
                        Image(systemName: sharedWorkoutInfo.workoutData?.gyroscopeSnapshots.isEmpty == false ? "checkmark" : "xmark")
                            .foregroundColor(sharedWorkoutInfo.workoutData?.gyroscopeSnapshots.isEmpty == false ? .green : .red)
                            .font(.system(size: 24, weight: .bold))
                            .padding(.trailing)
                    }
                }
                
                
                Section(header: Text("Notes")){
                    TextEditor(text: Binding(
                        get: { sharedWorkoutInfo.workoutInfo?.notes ?? "" },
                        set: { sharedWorkoutInfo.workoutInfo?.notes = $0 }
                    ))
                    .frame(minHeight: 100, maxHeight: .infinity)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(5, reservesSpace: true)
                }
                
                Section(header: Text("Confirmation")) {
                    Toggle("Data good for analysis", isOn: Binding(
                        get: { sharedWorkoutInfo.workoutInfo?.isDataGood ?? false },
                        set: { sharedWorkoutInfo.workoutInfo?.isDataGood = $0 }
                    ))
                }
                
                Button(action: {
                    // Save action, can be used to upload to the database
                    saveWorkout()
                }) {
                    Text("Upload")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Confirm Workout")
        }
    }
        
    
    func saveWorkout() {
        
        print(sharedWorkoutInfo)
            // Add logic to save or upload the workout
            if let workoutInfo = sharedWorkoutInfo.workoutInfo {
                let notesText = workoutInfo.notes ?? "No notes provided"
                print("Workout saved with notes: \(notesText), Data Good: \(workoutInfo.isDataGood)")
                // Implement the database upload logic here
            }
        }
}



struct WorkoutConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutConfirmationView()
            .environmentObject(SharedWorkoutInfo.mock) // Inject mock data
    }
}
