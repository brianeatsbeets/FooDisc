//
//  ScorecardViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 2/5/22.
//

import UIKit
import MapKit

// TODO: track par performance and other stats
// TODO: create more attractive UI
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
    
    var currentHoleNumber: Int
    var currentHoleScore: Int
    var selectedCourse: Course
    var scorecard: Scorecard
    
    // MARK: Initializers
    
    // Custom initializer to set courses array
    init?(coder: NSCoder, selectedCourse: Course) {
        self.selectedCourse = selectedCourse
        scorecard = Scorecard(course: selectedCourse)
        currentHoleNumber = 1
        currentHoleScore = 0
        super.init(coder: coder)
    }
    
    // Required initializer as a subclass of UIViewController
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        
        // Update current hole score label value
        currentHoleScoreLabel.text = String(currentHoleScore)
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
        
        // Update current hole score label value
        currentHoleScoreLabel.text = String(currentHoleScore)
    }
    
    // Set the previous hole as the current hole
    @IBAction func previousHoleButtonPressed(_ sender: Any) {
        if currentHoleNumber > 1 {
            currentHoleNumber -= 1
            currentHoleScore = 0
            
            // Update current hole label value
            currentHoleLabel.text = String(currentHoleNumber)
        }
    }
    
    // Set the next hole as the current hole
    @IBAction func nextHoleButtonPressed(_ sender: Any) {
        if currentHoleNumber < selectedCourse.layout.holes.count {
            currentHoleNumber += 1
            currentHoleScore = 0
            
            // Update current hole label value
            currentHoleLabel.text = String(currentHoleNumber)
        }
    }
    
    // Save scorecard data and dismiss the scorecard view controller
    @IBAction func finishRoundButtonPressed(_ sender: Any) {
        
        // Assert whether or not each hole was played
        for score in scorecard.scorePerHole {
            if score == 0 {
                scorecard.isScorecardComplete = false
            }
        }
        
        // Warn user if scorecard is incomplete
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
            index += 1
        }
        
        // Calculate total score
        for score in scorecard.scorePerHole {
            scorecard.totalScore += score
        }
        
        // Save scorecard
        var scorecards = fetchScorecardData()
        scorecards.append(scorecard)
        saveScorecardData(scorecards: scorecards)
        dismiss(animated: true, completion: nil)
    }
    
}
