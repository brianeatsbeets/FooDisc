//
//  ScorecardViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 2/5/22.
//

import UIKit
import MapKit

// TODO: be better at autolayout
// TODO: look into using initializers on these view controllers that are passed values like selectedCourse instead of loading up dummy data
// TODO: disable finish button until scorecard is filled out (or warn user before finishing early and auto-fill in "-" for other scores and parse that when calculating total score)
// TODO: track par performance and other stats
// This class/view controller displays and allows a user to complete a scorecard for the selected course
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
    @IBOutlet var currentHoleScoreLabel: UILabel!
    
    // Current score label in scorecard layout
    var layoutCurrentHoleScoreLabel: UILabel? {
        return self.view.viewWithTag(300+currentHoleNumber) as? UILabel
    }
    
    // Set with initializer
    var currentHoleNumber = 1 {
        didSet {
            // Adjust label text when this value changes
            currentHoleLabel.text = String(currentHoleNumber)
        }
    }
    
    // Set with initializer
    var currentHoleScore = 0 {
        didSet {
            // Adjust label text when this value changes
            currentHoleScoreLabel.text = String(currentHoleScore)
        }
    }
    
    // Set with initializer
    var scorecards: [Scorecard] = []
    
    // Set dummy course data to show in the event an invalid courseID is passed
    // Set with initializer
    var selectedCourse = Course(title: "Air Ball", city: "Whiff City", state: "Bogeyland", coordinate: CLLocationCoordinate2D()) {
        didSet {
            // Set actual scorecard for selectedCourse
            scorecard = Scorecard(course: selectedCourse)
        }
    }
    
    // Set dummy course data until actual course data arrives
    // Set with initializer
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
        // Won't need this with initializer
        currentHoleLabel.text = String(currentHoleNumber)
        currentHoleScoreLabel.text = String(currentHoleScore)
    }
    
    // MARK: UI interaction functions
    
    // Decrease current hole score by 1
    @IBAction func holeScoreMinusButtonPressed(_ sender: Any) {
        if currentHoleScore > 0 {
            currentHoleScore -= 1
        }
        
        // Update scorecard
        scorecard.scorePerHole[currentHoleNumber - 1] = currentHoleScore
        
        // Update the scorecard UI for this hole
        if layoutCurrentHoleScoreLabel != nil {
            layoutCurrentHoleScoreLabel!.text = String(currentHoleScore)
        }
    }
    
    // Increase current hole score by 1
    @IBAction func holeScorePlusButtonPressed(_ sender: Any) {
        currentHoleScore += 1
        
        // Update scorecard
        scorecard.scorePerHole[currentHoleNumber - 1] = currentHoleScore
        
        // Update the layout score for this hole
        if layoutCurrentHoleScoreLabel != nil {
            layoutCurrentHoleScoreLabel!.text = String(currentHoleScore)
        }
    }
    
    // Set the previous hole as the current hole
    @IBAction func previousHoleButtonPressed(_ sender: Any) {
        if currentHoleNumber > 1 {
            currentHoleNumber -= 1
            currentHoleScore = 0
        }
    }
    
    // Set the next hole as the current hole
    @IBAction func nextHoleButtonPressed(_ sender: Any) {
        if currentHoleNumber < selectedCourse.layout.holes.count {
            currentHoleNumber += 1
            currentHoleScore = 0
        }
    }
    
    // Save scorecard data and dismiss the scorecard view controller
    @IBAction func finishRoundButtonPressed(_ sender: Any) {
        
        // Assert whether or not each hole was played and warn user if scorecard is incomplete
        for score in scorecard.scorePerHole {
            if score == 0 {
                scorecard.isScorecardComplete = false
            }
        }
        
        if !scorecard.isScorecardComplete {
            let alert = UIAlertController(title: "Incomplete scorecard", message: "You have not entered a score for every hole on the scorecard. Do you still want to close the scorecard?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] action in
                finalizeScorecard()
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { [self] action in
                scorecard.isScorecardComplete = true
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            finalizeScorecard()
        }
    }
    
    // Calculate scorecard totals and stats and save scorecard
    func finalizeScorecard() {
        
        // Calculate total par score
        var index = 0
        while index < selectedCourse.layout.holes.count {
            scorecard.totalPar += scorecard.scorePerHole[index] - selectedCourse.layout.holePar[index]
            print("Hole par: \(selectedCourse.layout.holePar[index])")
            print("Hole score: \(scorecard.scorePerHole[index])")
            print("Total par: \(scorecard.totalPar)")
            index += 1
        }
        
        // Calculate total score
        for score in scorecard.scorePerHole {
            scorecard.totalScore += score
        }
        
        // Save scorecard
        scorecards.append(scorecard)
        saveScorecardData(scorecards: scorecards)
        dismiss(animated: true, completion: nil)
    }
    
}
