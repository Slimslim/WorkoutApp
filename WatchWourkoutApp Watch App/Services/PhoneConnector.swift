//
//  PhoneConnector.swift
//  WatchWourkoutApp Watch App
//
//  Created by Sélim Gawad on 7/1/24.
//

import Foundation
import WatchConnectivity

class PhoneConnector: NSObject, WCSessionDelegate, ObservableObject {
    
    // Singleton instance
    static let shared = PhoneConnector()
    
    // WCSession instance
    private let session: WCSession
    
//    init(session: WCSession = .default){
//        self.session = session
//        super.init()
//        session.delegate = self
//        session.activate()
//    }
    
    // Private initializer to enforce singleton pattern
    private override init() {
        if WCSession.isSupported() {
            self.session = WCSession.default
        } else {
            fatalError("WCSession is not supported on this device.")
        }
        super.init()
        self.session.delegate = self
        self.session.activate()
    }
    
    // WCSessionDelegate methods
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
    
    
    /// Sending a file to the phone
    func transferFileToPhone(fileURL: URL) {
        if WCSession.default.isReachable {
            WCSession.default.transferFile(fileURL, metadata: nil)
            print("File transfer initiated")
        } else {
            print("Watch is not reachable")
        }
    }
    
    /// Function to save the data in a file to transfer to the iPhone
    func saveWorkoutInfoToFile(completion: @escaping (URL) -> Void) {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentDirectory = urls.first else {
            print("Failed to access document directory")
            return
        }
        
        let fileURL = documentDirectory.appendingPathComponent("workoutData.json")
        
        do {
            let data = try JSONEncoder().encode(SharedWorkoutInfo.shared)
            try data.write(to: fileURL)
            print("Workout data saved to file: \(fileURL)")
            completion(fileURL)
        } catch {
            print("Failed to write workout data to file: \(error)")
        }
    }
    
    
}

