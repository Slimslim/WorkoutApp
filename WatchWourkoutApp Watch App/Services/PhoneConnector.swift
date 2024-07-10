//
//  PhoneConnector.swift
//  WatchWourkoutApp Watch App
//
//  Created by Sélim Gawad on 7/1/24.
//

import Foundation
import WatchConnectivity

class PhoneConnector: NSObject, WCSessionDelegate, ObservableObject {
    
    var session: WCSession
    
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
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        if !session.isCompanionAppInstalled {
            print("WCSession counterpart app not installed")
        }
    }
    
    /// Recieving Information
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let data = message["workoutInfo"] as? Data {
                do {
                    let workoutInfo = try JSONDecoder().decode(WorkoutInformation.self, from: data)
                    
                    // Handle received workoutInfo
                    SharedWorkoutInfo.shared.workoutId = UUID()
                    SharedWorkoutInfo.shared.workoutInfo = workoutInfo
                    SharedWorkoutInfo.shared.printWorkoutInfo() // Print the workout info upon receiving
                    //                    print("Received workout info: \(workoutInfo)")
                    // You can add additional handling logic here, such as storing the data or updating the UI
                } catch {
                    print("Failed to decode workout info: \(error)")
                }
            }
        }
    }
    
    
    /// Sending Information
    func sendDataToPhone(data: SharedWorkoutInfo) {
        if session.isReachable {
            do {
                let jsonData = try JSONEncoder().encode(data)
                let message = ["workoutInfo": jsonData]
                session.sendMessage(message, replyHandler: nil) { (error) in
                    print("Failed to send message: \(error.localizedDescription)")
                }
            } catch {
                print("Failed to encode workout info: \(error)")
            }
        } else {
            print("Phone is not reachable")
        }
    }
}

