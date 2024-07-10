////
////  MainViewController.swift
////  WorkoutApp
////
////  Created by Sélim Gawad on 7/3/24.
////
//
//import Foundation
//import UIKit
//
//class MainViewController: UIViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        
//        // Button to trigger the workout confirmation
//        let completeWorkoutButton = UIButton(type: .system)
//        completeWorkoutButton.setTitle("Complete Workout", for: .normal)
//        completeWorkoutButton.addTarget(self, action: #selector(completeWorkoutButtonTapped), for: .touchUpInside)
//        
//        completeWorkoutButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(completeWorkoutButton)
//        
//        NSLayoutConstraint.activate([
//            completeWorkoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            completeWorkoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//    
//    @objc private func completeWorkoutButtonTapped() {
//        presentWorkoutConfirmation()
//    }
//
//    func presentWorkoutConfirmation() {
//        let workoutConfirmationVC = WorkoutConfirmationViewController()
//        workoutConfirmationVC.saveHandler = { [weak self] notes, isDataGood in
//            self?.saveWorkout(notes: notes, isDataGood: isDataGood)
//        }
//        workoutConfirmationVC.modalPresentationStyle = .formSheet
//        present(workoutConfirmationVC, animated: true, completion: nil)
//    }
//
//    private func saveWorkout(notes: String, isDataGood: Bool) {
//        // Handle saving the workout information here
//        print("Workout saved with notes: \(notes), Data Good: \(isDataGood)")
//    }
//}
