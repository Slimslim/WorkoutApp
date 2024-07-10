////
////  WorkoutConfirmationViewController.swift
////  WorkoutApp
////
////  Created by Sélim Gawad on 7/3/24.
////
//
//import Foundation
//import UIKit
//
//class WorkoutConfirmationViewController: UIViewController {
//    
//    var saveHandler: ((String, Bool) -> Void)?
//
//    private let movementLabel = UILabel()
//    private let roundsLabel = UILabel()
//    private let repsLabel = UILabel()
//    private let weightLabel = UILabel()
//    private let accelerometerStatusLabel = UILabel()
//    private let gyroscopeStatusLabel = UILabel()
//    private let notesTextView = UITextView()
//    private let dataQualitySwitch = UISwitch()
//    private let saveButton = UIButton(type: .system)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        populateData()
//    }
//
//    private func setupUI() {
//        view.backgroundColor = .white
//
//        notesTextView.layer.borderColor = UIColor.gray.cgColor
//        notesTextView.layer.borderWidth = 1.0
//        notesTextView.layer.cornerRadius = 5.0
//
//        saveButton.setTitle("Save", for: .normal)
//        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
//
//        let stackView = UIStackView(arrangedSubviews: [
//            movementLabel,
//            roundsLabel,
//            repsLabel,
//            weightLabel,
//            accelerometerStatusLabel,
//            gyroscopeStatusLabel,
//            UILabel(text: "Notes:"),
//            notesTextView,
//            UILabel(text: "Data Quality:"),
//            dataQualitySwitch,
//            saveButton
//        ])
//        stackView.axis = .vertical
//        stackView.spacing = 10
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(stackView)
//
//        NSLayoutConstraint.activate([
//            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
//            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
//        ])
//    }
//
//    private func populateData() {
//        let sharedWorkoutInfo = SharedWorkoutInfo.shared
//
//        movementLabel.text = "Movement: \(sharedWorkoutInfo.workoutInfo?.movement ?? "")"
//        roundsLabel.text = "Rounds: \(sharedWorkoutInfo.workoutInfo?.rounds ?? 0)"
//        repsLabel.text = "Reps: \(sharedWorkoutInfo.workoutInfo?.reps ?? 0)"
//        weightLabel.text = "Weight: \(sharedWorkoutInfo.workoutInfo?.weight ?? 0)"
//
//        let accelerometerDataExists = !(sharedWorkoutInfo.workoutData?.accelerometerSnapshots.isEmpty ?? true)
//        let gyroscopeDataExists = !(sharedWorkoutInfo.workoutData?.gyroscopeSnapshots.isEmpty ?? true)
//
//        accelerometerStatusLabel.text = accelerometerDataExists ? "Accelerometer Data: ✅" : "Accelerometer Data: ❌"
//        gyroscopeStatusLabel.text = gyroscopeDataExists ? "Gyroscope Data: ✅" : "Gyroscope Data: ❌"
//    }
//
//    @objc private func saveButtonTapped() {
//        let notes = notesTextView.text ?? ""
//        let isDataGood = dataQualitySwitch.isOn
//        saveHandler?(notes, isDataGood)
//        dismiss(animated: true, completion: nil)
//    }
//    
//}
//
//extension UILabel {
//    convenience init(text: String) {
//        self.init()
//        self.text = text
//    }
//}
