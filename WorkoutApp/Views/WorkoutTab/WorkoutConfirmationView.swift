//
//  WorkoutConfirmationView.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 7/3/24.
//

import Foundation
import SwiftUI
import RealmSwift

struct WorkoutConfirmationView: View {
    
    // binding argument to present the confirmation window
    @Binding var isPresented: Bool
    
    /// Fetching data and sort itby date created
    @ObservedResults(Workout.self, sortDescriptor: SortDescriptor(keyPath: "created", ascending: false)) var workouts
    @Environment(\.realm) var realm
    
    @State private var busy = false
    
    
    
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
                    addWorkout()
                }) {
                    Text("Upload")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .onAppear(perform: { subscribe() })
            .onDisappear( perform: { unsubscribe() })
            .navigationTitle("Confirm Workout")
        }
    }
    
    
    func addWorkout() {
        
        print(sharedWorkoutInfo)
        
        // Access the shared workout info singleton
        let sharedInfo = SharedWorkoutInfo.shared
        
        // Ensure workoutInfo and workoutData are available
        guard let workoutInfo = sharedInfo.workoutInfo else {
            print("No workout info available.")
            return
        }

        // Convert the data to Realm objects
        let realmWorkoutInfo = WorkoutInfo(
            movement: workoutInfo.movement,
            rounds: workoutInfo.rounds,
            reps: workoutInfo.reps,
            weight: workoutInfo.weight
        )
        
//        let realmAccelerometerData = workoutData.accelerometerSnapshots.map {
//            AccelerometerData(timestamp: $0.timestamp, accelerationX: $0.accelerationX, accelerationY: $0.accelerationY, accelerationZ: $0.accelerationZ)
//        }
//        
//        let realmGyroscopeData = workoutData.gyroscopeSnapshots.map {
//            GyroscopeData(timestamp: $0.timestamp, rotationX: $0.rotationX, rotationY: $0.rotationY, rotationZ: $0.rotationZ)
//        }
        
        // Convert accelerometer data if available
        let realmAccelerometerData = sharedInfo.workoutData?.accelerometerSnapshots.map {
            AccelerometerData(timestamp: $0.timestamp, accelerationX: $0.accelerationX, accelerationY: $0.accelerationY, accelerationZ: $0.accelerationZ)
        } ?? []
        
        // Convert gyroscope data if available
        let realmGyroscopeData = sharedInfo.workoutData?.gyroscopeSnapshots.map {
            GyroscopeData(timestamp: $0.timestamp, rotationX: $0.rotationX, rotationY: $0.rotationY, rotationZ: $0.rotationZ)
        } ?? []
        
        
        let realmWorkoutData = WorkoutData(accelerometerSnapshots: realmAccelerometerData, gyroscopeSnapshots: realmGyroscopeData)
        
        // Create the Workout object
        let workout = Workout(
            created: Date(),
            username: workoutInfo.username,
            notes: workoutInfo.notes,
            isDataGood: workoutInfo.isDataGood,
            info: realmWorkoutInfo,
            data: realmWorkoutData
        )
        
        $workouts.append(workout)
        
        print("Workout added to Realm successfully.")
        
        // Clear out values after upload
        clearWorkout()
        
        // Dismiss the view
        isPresented = false
    }
    
    private func subscribe (){
        let subscriptions = realm.subscriptions
        if subscriptions.first(named: "allWorkouts") == nil {
            busy = true
            subscriptions.update {
                subscriptions.append(QuerySubscription<Workout>(name: "allWorkouts"))
            } onComplete: { error in
                if let error = error {
                    print("Failed to subscribe for all workouts: \(error.localizedDescription)")
                }
            }
            busy = false
        }
    }
    
    
    private func unsubscribe () {
        let subscriptions = realm.subscriptions
        subscriptions.update {
            subscriptions.remove(named: "allWorkouts")
        } onComplete: { error in
            if let error = error{
                print("Failed to unsubscripe for \("allWorkouts"): \(error.localizedDescription)")
            }
        }
    }
    
    func clearWorkout() {
        DispatchQueue.main.async {
            // Reset shared workout info
            SharedWorkoutInfo.shared.reset()
        }
    }
}





//struct WorkoutConfirmationView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutConfirmationView()
//            .environmentObject(SharedWorkoutInfo.mock) // Inject mock data
//    }
//}
