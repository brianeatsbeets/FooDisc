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
    @IBOutlet var totalCourseDistanceLabel: UILabel!
    @IBOutlet var numberOfHolesLabel: UILabel!
    @IBOutlet var parTotalLabel: UILabel!
    @IBOutlet var holeNumberLabel: [UILabel]!
    @IBOutlet var holeDistanceLabel: [UILabel]!
    @IBOutlet var holeParLabel: [UILabel]!
    @IBOutlet var holeScoreLabel: [UILabel]!
    
    // Set dummy course data to show in the event an invalid courseID is passed
    var selectedCourse = Course(title: "Air Ball", city: "Whiff City", state: "Bogeyland", coordinate: CLLocationCoordinate2D())

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }
    
    // Fill the UI elements with selected course data
    func initializeUI() {
        courseNameLabel.text = selectedCourse.title
        
        numberOfHolesLabel.text = "\(selectedCourse.layout.holes.count) holes"
        parTotalLabel.text = "Par \(selectedCourse.layout.holePar.reduce(0, +))"
        totalCourseDistanceLabel.text = "\(selectedCourse.layout.holeDistance.reduce(0, +))ft"
        
        let layout = selectedCourse.layout
        
        for index in layout.holes {
            let holeNumberLabel = self.view.viewWithTag(index) as! UILabel
            holeNumberLabel.text = String(layout.holes[index - 1])
            
            let holeDistanceLabel = self.view.viewWithTag(index + 100) as! UILabel
            holeDistanceLabel.text = String(layout.holeDistance[index - 1])
            
            let holeParLabel = self.view.viewWithTag(index + 200) as! UILabel
            holeParLabel.text = String(layout.holePar[index - 1])
        }
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
