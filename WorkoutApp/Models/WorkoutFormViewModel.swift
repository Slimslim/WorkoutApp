//
//  WorkoutFormViewModel.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 7/3/24.
//

import Foundation
import SwiftUI

protocol WorkoutDataReceiver: AnyObject {
    func didReceiveWorkoutInfo()
}

class WorkoutFormViewModel: ObservableObject, WorkoutDataReceiver {
    @Published var showingWorkoutConfirmation = false
    @Published var notes: String = ""
    @Published var isDataGood: Bool = false
    private var watchConnector: WatchConnector

    init() {
        self.watchConnector = WatchConnector()
        self.watchConnector.delegate = self
    }

    func didReceiveWorkoutInfo() {
        DispatchQueue.main.async {
            self.showingWorkoutConfirmation = true
        }
    }

    func sendWorkoutInfoToWatch(_ workoutInfo: WorkoutInformation) {
        watchConnector.sendWorkoutInfoToWatch(workoutInfo)
    }
}
