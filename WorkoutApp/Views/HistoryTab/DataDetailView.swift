//
//  DataDetailView.swift
//  WorkoutApp
//
//  Created by Sélim Gawad on 8/27/24.
//

import SwiftUI
import Charts
import RealmSwift

struct DataDetailView: View {
    let workout: Workout // A single workout data to display details
    @State private var busy = false
    
    /// Fetching all CoreMotionData
    @ObservedResults(CoreMotionData.self) var allWorkoutData // Observe all CoreMotionData
    @Environment(\.realm) var realm
    
    // Computed property to filter results based on workout ID
    private var workoutData: Results<CoreMotionData> {
        allWorkoutData.where { $0.workoutId == workout._id }
    }
    
    // Consolidated data properties
    @State private var consolidatedAccelerometerData: [AccelerometerData] = []
    @State private var consolidatedGyroscopeData: [GyroscopeData] = []
    
    
    
    var body: some View {
        List {
            // Information Section
            Section(header: Text("Data information")){
                HStack{
                    
                }
            }
            
            Section(header: Text("Data collected")) {
                // Accelerometer Data
                HStack {
                    VStack(alignment: .leading) {
                        Text("Accelerometer Data")
                        HStack {
                            Text("Entries: \(consolidatedAccelerometerData.count)")
                                .font(.caption)
                                .foregroundColor(.gray)
                            if let accelerometerRate = workoutData.first?.accelerometerRate {
                                Text("Rate: \(accelerometerRate) Hz")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                // Gyroscope Data
                HStack {
                    VStack(alignment: .leading) {
                        Text("Gyroscope Data")
                        HStack {
                            Text("Entries: \(consolidatedGyroscopeData.count)")
                                .font(.caption)
                                .foregroundColor(.gray)
                            if let gyroscopeRate = workoutData.first?.gyroscopeRate {
                                Text("Rate: \(gyroscopeRate) Hz")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            
            // Accelerometer Section
            Section(header: Text("Accelerometer")) {
                if consolidatedAccelerometerData.isEmpty {
                    Text("No accelerometer data available.")
                } else {
                    AccelerometerChartView(data: consolidatedAccelerometerData)
                        .frame(height: 200)
                }
            }
            
            // Gyroscope Section
            Section(header: Text("Gyroscope")) {
                if consolidatedGyroscopeData.isEmpty {
                    Text("No gyroscope data available.")
                } else {
                    GyroscopeChartView(data: consolidatedGyroscopeData)
                        .frame(height: 200)
                }
            }
        }
        .navigationTitle("\(workout.info?.movement ?? "Unknown Movement") Details")
        .listStyle(.grouped)
//        /// Subscribe and unsubscribe from databse when in the view
        .onAppear{
//            // Subscribe to both Workouts and CoreMotionData
//            MongoDbManager.shared.subscribe(realm: realm, busy: $busy)
//            MongoDbManager.shared.subscribeToCoreMotionData(realm: realm, busy: $busy)
            consolidateData()
        }
//        .onDisappear{
//            MongoDbManager.shared.unsubscribe(realm: realm, busy: $busy)
//            MongoDbManager.shared.unsubscribeFromCoreMotionData(realm: realm, busy: $busy) // Unsubscribe from CoreMotionData
//        }
    }
    
    // Consolidate accelerometer and gyroscope data from all batches
    private func consolidateData() {
        // Sort the workoutData by batchNumber to ensure correct order
        let sortedWorkoutData = workoutData.sorted(by: { $0.batchNumber < $1.batchNumber })
        
        // Consolidate accelerometer and gyroscope data in the correct order
        consolidatedAccelerometerData = sortedWorkoutData.flatMap { $0.accelerometerSnapshots }
        consolidatedGyroscopeData = sortedWorkoutData.flatMap { $0.gyroscopeSnapshots }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func calculateDuration() -> String {
        // Implement logic to calculate duration in minutes and seconds
        guard let startTime = workout.info?.startTime, let endTime = workout.info?.endTime else {
            return "Unknown Duration"
        }
        let duration = endTime.timeIntervalSince(startTime)
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}


// Accelerometer Chart View
struct AccelerometerChartView: View {
    let data: [AccelerometerData]
    
    var body: some View {
        // Determine the minimum timestamp to normalize time
        let minTimestamp = data.map { $0.timestamp }.min() ?? 0
        let maxTimestamp = data.map { $0.timestamp }.max() ?? 1 // Ensure max is greater than min
        
//        Chart {
//            // Plot X-axis data only
//            ForEach(data) { dataPoint in
//                LineMark(
//                    x: .value("Time", dataPoint.timestamp - minTimestamp),
//                    y: .value("X", dataPoint.accelerationX)
//                )
//                .foregroundStyle(Color.red)
//                .lineStyle(StrokeStyle(lineWidth: 2))
//            }
//        }
//        .chartXScale(domain: (0...(maxTimestamp - minTimestamp))) // Corrected range for X-axis
//        .chartYAxis {
//            AxisMarks(position: .leading)
//        }
//        .frame(height: 300) // Adjust height as needed
//        .padding()
    }
}

// Gyroscope Chart View
struct GyroscopeChartView: View {
    let data: [GyroscopeData]
    
    var body: some View {
        Chart {
            ForEach(data, id: \.timestamp) { dataPoint in
                LineMark(
                    x: .value("Time", dataPoint.timestamp),
                    y: .value("X", dataPoint.rotationX)
                )
                .foregroundStyle(.red)
                
                LineMark(
                    x: .value("Time", dataPoint.timestamp),
                    y: .value("Y", dataPoint.rotationY)
                )
                .foregroundStyle(.green)
                
                LineMark(
                    x: .value("Time", dataPoint.timestamp),
                    y: .value("Z", dataPoint.rotationZ)
                )
                .foregroundStyle(.blue)
            }
        }
    }
}
