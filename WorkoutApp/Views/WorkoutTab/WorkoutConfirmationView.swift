//
//  WorkoutConfirmationView.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 7/3/24.
//

import Foundation
import SwiftUI
import RealmSwift

/// A view that allows the user to confirm and upload a workout to the database.
struct WorkoutConfirmationView: View {
    
    /// Binding argument to present the confirmation window.
    @Binding var isPresented: Bool
    
    /// Fetching and sorting workout data by the date created.
    @ObservedResults(Workout.self, sortDescriptor: SortDescriptor(keyPath: "created", ascending: false)) var workouts
    @Environment(\.realm) var realm
    @State private var busy = false
    
    
    
    /// Shared workout information.
    @EnvironmentObject var sharedWorkoutInfo: SharedWorkoutInfo
    @EnvironmentObject var stateManager: WorkoutStateManager
    
    /// Computed property to get the selected movement.
    var selectedMovement: WorkoutMovement? {
        guard let movementName = sharedWorkoutInfo.workoutInfo?.movement else {
            return nil
        }
        return workoutMovements.first { $0.name == movementName }
    }
    
    var body: some View {
        NavigationView {
            Form {
                /// Section to input user information.
                Section(header: Text("User Information")) {
                    HStack{
                        Text("Username: ")
                        TextField("Username", text: Binding(
                            get: { sharedWorkoutInfo.workoutInfo?.username ?? "" },
                            set: { sharedWorkoutInfo.workoutInfo?.username = $0 }
                        ))
                    }
                    
                }
                
                /// Section to input workout details.
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
                
                /// Section to display collected data status.
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
                
                /// Section for additional notes about the workout.
                Section(header: Text("Notes")){
                    TextEditor(text: Binding(
                        get: { sharedWorkoutInfo.workoutInfo?.notes ?? "" },
                        set: { sharedWorkoutInfo.workoutInfo?.notes = $0 }
                    ))
                    .frame(minHeight: 100, maxHeight: .infinity)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(5, reservesSpace: true)
                }
                
                /// Section to confirm data quality for analysis.
                Section(header: Text("Confirmation")) {
                    Toggle("Data good for analysis", isOn: Binding(
                        get: { sharedWorkoutInfo.workoutInfo?.isDataGood ?? false },
                        set: { sharedWorkoutInfo.workoutInfo?.isDataGood = $0 }
                    ))
                }
                
                /// Button to upload the workout and associated data to the database.
                Button(action: {
                    // Save action, can be used to upload to the database
                    addWorkout()
                }) {
                    Text("Upload")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .onAppear{
                // Subscribe to both Workouts and CoreMotionData
                MongoDbManager.shared.subscribe(realm: realm, busy: $busy)
                MongoDbManager.shared.subscribeToCoreMotionData(realm: realm, busy: $busy)
            }
            .onDisappear{
                stateManager.transitionTo(.waitingForPhone)
                MongoDbManager.shared.unsubscribe(realm: realm, busy: $busy)
                MongoDbManager.shared.unsubscribeFromCoreMotionData(realm: realm, busy: $busy) // Unsubscribe from CoreMotionData
            }
            .navigationTitle("Confirm Workout")
        }
    }
    
    /// Saves the workout and associated data into Realm/MongoDB.
    func addWorkout() {
        print(sharedWorkoutInfo)
        
        // Access the shared workout info singleton.
        let sharedInfo = SharedWorkoutInfo.shared
        
        // Ensure workoutInfo and workoutData are available.
        guard let workoutInfo = sharedInfo.workoutInfo, let workoutData = sharedInfo.workoutData else {
            print("No workout info or data available.")
            return
        }
        
        // Get the start and end time from the motion data
        let (startTime, endTime) = workoutData.getStartAndEndTime()
        
        // Create the Workout object (without data).
        let workout = Workout(
            created: Date(),
            username: workoutInfo.username,
            notes: workoutInfo.notes,
            isDataGood: workoutInfo.isDataGood,
            info: WorkoutInfo(
                movement: workoutInfo.movement,
                rounds: workoutInfo.rounds,
                reps: workoutInfo.reps,
                weight: workoutInfo.weight,
                startTime: startTime,  // Set the start time from the extracted data
                endTime: endTime,  // Set the end time from the extracted data
                numberOfBatches: nil // Will be set after batching
            )
        )
        
        // Save the Workout to Realm/MongoDB.
        try? realm.write {
            realm.add(workout)
        }
        
        // Batch the workout data and save the batches.
        let workoutId = workout._id
        saveCoreMotionDataBatches(workoutId: workoutId)
        
        // Update the number of batches in WorkoutInfo.
        try? realm.write {
            workout.info?.numberOfBatches = sharedInfo.workoutData?.getNumberOfBatches() // Method to be defined
        }
        
        print("Workout and data batches added to Realm successfully.")
        
        // Clear out values after upload.
        clearWorkout()
        
        // Dismiss the view.
        stateManager.transitionTo(.waitingForPhone)
    }
    
    /// Batches the workout data and saves it in separate `CoreMotionData` objects.
    /// - Parameter workoutId: The unique identifier of the workout.
    func saveCoreMotionDataBatches(workoutId: ObjectId) {
        guard let workoutData = sharedWorkoutInfo.workoutData else {
            print("No workout data available.")
            return
        }
        
        // Implement batching logic here based on time intervals.
        let batches = workoutData.batchByTimeInterval() // Method to be defined
        
        for (index, batch) in batches.enumerated() {
            
            // Use the getStartAndEndTime function to get start and end times
            let (startTime, endTime) = batch.getStartAndEndTime()
            
            // Ensure that startTime and endTime are non-nil
            guard let validStartTime = startTime, let validEndTime = endTime else {
                print("Invalid start or end time for batch \(index + 1)")
                continue
            }
            
            // Convert the accelerometer snapshots from `AccelerometerSnapshot` to `AccelerometerData`.
            let accelerometerData = batch.accelerometerSnapshots.toAccelerometerData()
            
            // Convert the gyroscope snapshots from `GyroscopeSnapshot` to `GyroscopeData`.
            let gyroscopeData = batch.gyroscopeSnapshots.toGyroscopeData()
            
            // Create a new `CoreMotionData` object for this batch, including the converted data.
            let coreMotionData = CoreMotionData(
                workoutId: workoutId,             // Link this batch to the workout by its ID.
                batchNumber: index + 1,           // Track the order of the batch.
                startTime: validStartTime,        // The start time of this batch.
                endTime: validEndTime,            // The end time of this batch.
                accelerometerRate: workoutData.accelerometerRate, // Capture rate for the accelerometer.
                gyroscopeRate: workoutData.gyroscopeRate,         // Capture rate for the gyroscope.
                accelerometerSnapshots: accelerometerData,        // The converted accelerometer data.
                gyroscopeSnapshots: gyroscopeData                 // The converted gyroscope data.
            )
            
            // Save each batch to Realm/MongoDB.
            do {
                try realm.write {
                    realm.add(coreMotionData)
                }
                print("Successfully saved batch \(index + 1)")
            } catch {
                print("Failed to save batch \(index + 1): \(error.localizedDescription)")
            }
        }
    }
    
    /// Clears the workout data after it has been uploaded.
    func clearWorkout() {
        DispatchQueue.main.async {
            // Reset shared workout info
            SharedWorkoutInfo.shared.reset()
        }
    }
}
