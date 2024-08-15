//
//  AudioAndHaptics.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 7/22/24.
//

import Foundation
import AVFoundation
import CoreHaptics

class Services {
    
    static let shared = Services()
    
    private var hapticEngine: CHHapticEngine?
    
    private init() {
        // Initialize the haptic engine if supported
        if CHHapticEngine.capabilitiesForHardware().supportsHaptics {
            do {
                hapticEngine = try CHHapticEngine()
                try hapticEngine?.start()
            } catch {
                print("Failed to start haptic engine: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Audio Session Management
    
    func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
            print("Audio session configured and activated")
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }
    
    func deactivateAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
            print("Audio session deactivated")
        } catch {
            print("Failed to deactivate audio session: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Haptic Feedback Management
    
    func playHapticPattern() {
        guard let hapticEngine = hapticEngine else { return }
        
        let pattern = try? CHHapticPattern(events: [CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0)], parameterCurves: [])
        
        do {
            let player = try hapticEngine.makePlayer(with: pattern!)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("Failed to play haptic pattern: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Application Lifecycle Hooks (Optional)
    
    func applicationDidEnterBackground() {
        deactivateAudioSession()
        stopHapticEngine()
    }
    
    func applicationWillEnterForeground() {
        configureAudioSession()
        startHapticEngine()
    }
    
    private func stopHapticEngine() {
        hapticEngine?.stop()
        print("Haptic engine stopped")
    }
    
    private func startHapticEngine() {
        do {
            try hapticEngine?.start()
            print("Haptic engine started")
        } catch {
            print("Failed to start haptic engine: \(error.localizedDescription)")
        }
    }
}
