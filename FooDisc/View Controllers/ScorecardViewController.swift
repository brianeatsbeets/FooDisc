//
//  ScorecardViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 2/5/22.
//

import UIKit
import MapKit

// TODO: fix y in Course Layout clipping
class ScorecardViewController: UIViewController {
    
    // MARK: Variable declarations
    @IBOutlet var courseNameLabel: UILabel!
    @IBOutlet var numberOfHolesLabel: UILabel!
    @IBOutlet var parTotalLabel: UILabel!
    @IBOutlet var totalCourseDistanceLabel: UILabel!
    @IBOutlet var holeNumberLabel: [UILabel]!
    @IBOutlet var holeDistanceLabel: [UILabel]!
    @IBOutlet var holeParLabel: [UILabel]!
    @IBOutlet var holeScoreLabel: [UILabel]!
    
    @IBOutlet var currentHoleLabel: UILabel!
    @IBOutlet var currentHoleScoreTextField: UITextField!
    @IBOutlet var saveScoreForHoleButton: UIButton!
    
    var currentHoleNumber = 1
    
    // Set dummy course data to show in the event an invalid courseID is passed
    var selectedCourse = Course(title: "Air Ball", city: "Whiff City", state: "Bogeyland", coordinate: CLLocationCoordinate2D())

    // MARK: Class functions
    
    // Load up the UI
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }
    
    // Fill the UI elements with selected course data
    func initializeUI() {
        
        // Course information
        courseNameLabel.text = selectedCourse.title
        numberOfHolesLabel.text = "\(selectedCourse.layout.holes.count) holes"
        parTotalLabel.text = "Par \(selectedCourse.layout.holePar.reduce(0, +))"
        totalCourseDistanceLabel.text = "\(selectedCourse.layout.holeDistance.reduce(0, +))ft"
        
        // Course layout
        let layout = selectedCourse.layout
        for index in layout.holes {
            let holeNumberLabel = self.view.viewWithTag(index) as! UILabel
            holeNumberLabel.text = String(layout.holes[index - 1])
            
            let holeDistanceLabel = self.view.viewWithTag(index + 100) as! UILabel
            holeDistanceLabel.text = String(layout.holeDistance[index - 1])
            
            let holeParLabel = self.view.viewWithTag(index + 200) as! UILabel
            holeParLabel.text = String(layout.holePar[index - 1])
        }
        
        // Current hole elements
        currentHoleLabel.text = "Hole \(currentHoleNumber)"
        saveScoreForHoleButton.isEnabled = false
        currentHoleScoreTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    // MARK: UI interaction functions
    
    // Check if the currentHoleScoreTextField has text, and if so, enable the save button
    @objc func textFieldDidChange(_ textField: UITextField) {
        if !textField.hasText {
            if saveScoreForHoleButton.isEnabled {
                saveScoreForHoleButton.isEnabled = false
            }
        } else {
            saveScoreForHoleButton.isEnabled = true
        }
    }
    
    // Dismiss the scorecard view and return to the previous view
    @IBAction func exitButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Add the current hole score to the scorecard and start the next hole
    @IBAction func saveScoreForHoleButtonPressed(_ sender: Any) {
        guard let scoreForHoleLabel = self.view.viewWithTag(300+currentHoleNumber) as? UILabel else { return }
        scoreForHoleLabel.text = currentHoleScoreTextField.text!
        currentHoleScoreTextField.text = ""
        
        if currentHoleNumber < 18 {
            currentHoleNumber += 1
            currentHoleLabel.text = "Hole \(currentHoleNumber)"
        }
    }
    
    // Manually return to a previous hole
    @IBAction func previousHoleButtonPressed(_ sender: Any) {
        if currentHoleNumber > 1 {
            currentHoleNumber -= 1
            currentHoleLabel.text = "Hole \(currentHoleNumber)"
        }
    }
    
    // Manually skip to an upcoming hole
    @IBAction func nextHoleButtonPressed(_ sender: Any) {
        if currentHoleNumber < 18 {
            currentHoleNumber += 1
            currentHoleLabel.text = "Hole \(currentHoleNumber)"
        }
    }
    
}
