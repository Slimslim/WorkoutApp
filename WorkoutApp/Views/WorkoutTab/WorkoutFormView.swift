//
//  WorkoutFormView.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 6/26/24.
//

import SwiftUI

struct WorkoutFormView: View {
    
    @StateObject private var viewModel = WorkoutFormViewModel()
    @EnvironmentObject var watchConnector: WatchConnector
    
    @State private var showingWorkoutConfirmation = false
    
    // Initialize SharedWorkoutInfo to be used in all child views before saving it to database
    @StateObject private var sharedWorkoutInfo = SharedWorkoutInfo.shared
    

    
    
    // initialize App Data. Workout movements and usernames
    @State private var selectedUsername: String
    @State private var selectedMovement: WorkoutMovement
    init(){
        _selectedUsername = State(initialValue: usernames.first ?? "Selim")
        _selectedMovement = State(initialValue: workoutMovements.first ?? WorkoutMovement(name: "Back Squat", isWeighted: true))
    }
    
    @State private var rounds: Int = 1
    @State private var reps: Int = 1
    @State private var weight: String = ""
    @State private var notes: String = ""
    @State private var isDataGood: Bool = false
    

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Information")) {
                    Picker("Username", selection: $selectedUsername) {
                        ForEach(usernames, id: \.self) { username in
                            Text(username).tag(username)
                        }
                    }
                }
                
                Section(header: Text("Workout Details")) {
                    Picker("Movement: ", selection: $selectedMovement) {
                        ForEach(workoutMovements, id: \.self) { movement in
                            Text(movement.name).tag(movement)
                        }
                    }
                    Stepper("Rounds: \(rounds)", value: $rounds)
                    Stepper("Reps: \(reps)", value: $reps)
                    if selectedMovement.isWeighted{
                        HStack{
                            Text("Weight: ")
                            TextField("Weight", text: $weight)
                                .keyboardType(.decimalPad)
                            Text("lbs")
                        }
                    }
                }
                
                Button(action: submitWorkout) {
                    Text("Submit")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .disabled(selectedMovement.isWeighted && weight.isEmpty)
                    /// Add a disable if the watch is not connected.
                    /// Maybe add a text to indicate that the watch is not connecte
                }
            }
            .navigationTitle("New Workout")
            .scrollDismissesKeyboard(.immediately)
        }
        .sheet(isPresented: $watchConnector.isShowingWorkoutConfirmationView) {
            WorkoutConfirmationView(isPresented: $showingWorkoutConfirmation)
        }
    }
    
    func submitWorkout() {
        
        // Handle the weight input
        var weightDouble: Double? = nil
        if selectedMovement.isWeighted {
            guard let validWeight = Double(weight), !weight.isEmpty else {
                print("Invalid input for weight")
                return
            }
            weightDouble = validWeight
        } else {
            weightDouble = nil
        }
        
        
        let workoutInfo = WorkoutInformation(
            date: Date(),
            username: selectedUsername,
            movement: selectedMovement.name,
            rounds: rounds,
            reps: reps,
            weight: weightDouble,
            notes: "",
            isDataGood: false
        )
        
        // Handle the form submission
        print("workoutData sent to Watch: \(workoutInfo)")
        watchConnector.sendWorkoutInfoToWatch(workoutInfo)
    }
    
}




struct WorkoutFormView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutFormView()
    }
}


