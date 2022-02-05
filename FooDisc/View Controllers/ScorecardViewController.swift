//
//  ScorecardViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 2/5/22.
//

import UIKit
import MapKit

// TODO: disable finish button until scorecard is filled out (or warn user before finishing early and auto-fill in "-" for other scores and parse that when calculating total score)
// TODO: look into using initializers on these view controllers that are passed values like selectedCourse instead of loading up dummy data
// TODO: fix y in Course Layout clipping
// This class/view controller displays and allows a user to complete a scorecard
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
    var scorecards: [Scorecard] = []
    
    // Set dummy course data to show in the event an invalid courseID is passed
    var selectedCourse = Course(title: "Air Ball", city: "Whiff City", state: "Bogeyland", coordinate: CLLocationCoordinate2D()) {
        didSet {
            // Set actual scorecard for selectedCourse
            scorecard = Scorecard(course: selectedCourse)
        }
    }
    
    // Set dummy course data until actual course data arrives
    var scorecard = Scorecard(course: Course(title: "Air Ball", city: "Whiff City", state: "Bogeyland", coordinate: CLLocationCoordinate2D()))

    // MARK: Class functions
    
    // Load up the UI
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scorecards = fetchScorecardData()
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
        
        // Set scorecard score for current hole
        scorecard.scorePerHole[currentHoleNumber] = Int(currentHoleScoreTextField.text!)
        
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
    
    // Save scorecard data and dismiss the scorecard view controller
    @IBAction func finishRoundButtonPressed(_ sender: Any) {
        scorecards.append(scorecard)
        saveScorecardData(scorecards: scorecards)
        dismiss(animated: true, completion: nil)
    }
    
}
