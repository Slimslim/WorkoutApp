//
//  WatchConnector.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 7/1/24.
//

import Foundation
import WatchConnectivity

//protocol WorkoutDataReceiver: AnyObject {
//    func didReceiveWorkoutInfo()
//}

class WatchConnector: NSObject, WCSessionDelegate, ObservableObject {
    
    var session: WCSession
    weak var delegate: WorkoutDataReceiver?
    
    //Variable to show workout for confirmation. Flag to trigger Confirmation view
    @Published var isShowingWorkoutConfirmationView = false
    
    
    init(session: WCSession = .default){
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WCSession activated with state: \(activationState.rawValue)")
        if !WCSession.default.isPaired {
            print("iPhone is not paired with an Apple Watch")
        }
        if !WCSession.default.isWatchAppInstalled {
            print("Counterpart app is not installed on Apple Watch")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        // Handle the session becoming inactive if necessary
        print("WCSession did become inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // Re-activate the session
        print("WCSession did deactivate")
        session.activate()
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        if session.isWatchAppInstalled {
            print("Watch app is installed")
        } else {
            print("Watch app is not installed")
        }
    }
    
    // Sending Workout information to the watch before starting data collection
    func sendWorkoutInfoToWatch(_ workoutInfo: WorkoutInformation) {
        guard WCSession.default.isReachable else {
            print("Watch is not reachable")
            return
        }
        do {
            let data = try JSONEncoder().encode(workoutInfo)
            let message = ["workoutInfo": data]
            WCSession.default.sendMessage(message, replyHandler: nil) { error in
                print("Error sending message: \(error.localizedDescription)")
            }
        } catch {
            print("Failed to encode workout info: \(error)")
        }
    }
    
    // Receiving SharedWorkoutInfo from the watch
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let data = message["workoutInfo"] as? Data {
                do {
                    let sharedWorkoutInfo = try JSONDecoder().decode(SharedWorkoutInfo.self, from: data)
                    // Handle the received sharedWorkoutInfo
                    self.processReceivedWorkoutInfo(sharedWorkoutInfo)
                } catch {
                    print("Failed to decode SharedWorkoutInfo: \(error)")
                }
            }
        }
    }
    
    // Process the received SharedWorkoutInfo
    func processReceivedWorkoutInfo(_ sharedWorkoutInfo: SharedWorkoutInfo) {
        
        // Update the singleton instance with received data
        SharedWorkoutInfo.shared.workoutId = sharedWorkoutInfo.workoutId
        SharedWorkoutInfo.shared.workoutInfo = sharedWorkoutInfo.workoutInfo
        SharedWorkoutInfo.shared.workoutData = sharedWorkoutInfo.workoutData
        
        // Print the received workout info for verification
        SharedWorkoutInfo.shared.printWorkoutInfo()
        
        // Set confitmation view to display
        isShowingWorkoutConfirmationView = true
        
        // Add additional logic to handle the received data as needed
        delegate?.didReceiveWorkoutInfo()
    }
    
}
