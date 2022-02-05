//
//  CourseDetailTableViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 2/3/22.
//

import UIKit
import MapKit

// TODO: have map show the course location and disable interactiability
// TODO: add functionality to Get Directions and Create Scorecard buttons
    // TODO: display a separate highlight background color for button presses
class CourseDetailTableViewController: UITableViewController {
    
    // MARK: Variable declarations
    
    @IBOutlet var courseTitleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var distanceFromUserLabel: UILabel!
    @IBOutlet var courseDetailMapView: MKMapView!
    @IBOutlet var courseConditionsView: UIView!
    @IBOutlet var courseConditionsLabel: UILabel!
    
    var courses: [Course] = []
    var courseID = ""
    
    // Set dummy course data to show in the event an invalid courseID is passed
    var selectedCourse = Course(title: "Air Ball", city: "Whiff City", state: "Bogeyland", coordinate: CLLocationCoordinate2D())
    
    // Set up a CoursesDelegate instance so we can talk to CoursesViewController
    weak var delegate: CoursesDelegate?
    
    // MARK: Class functions
    
    // Set up table view, grab selected course, and configure UI elements
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "LayoutTableViewCell", bundle: nil), forCellReuseIdentifier: "LayoutCell")
        courseConditionsView.layer.cornerRadius = 5
        
        fetchSelectedCourse()
        initializeUI()
    }
    
    // Fill the UI elements with selected course data
    func initializeUI() {
        self.title = selectedCourse.title
        
        courseTitleLabel.text = selectedCourse.title
        locationLabel.text = selectedCourse.city + ", " + selectedCourse.state
        
        // Validate that we have a distance from user for the course
        if let distance = selectedCourse.distanceFromUser {
            distanceFromUserLabel.text = String(distance) + "mi"
        } else {
            distanceFromUserLabel.text = ""
            print("Distance from user for course \(String(describing: selectedCourse.title)) is nil")
        }
        
        updateCourseConditionsUI()
    }
    
    // Using the provided courseID, parse the courses array and grab the selected course
    func fetchSelectedCourse() {

        // Filter out selected course
        if let course = courses.filter({ $0.id == courseID }).first {
            selectedCourse = course
        } else {
            // If selected course was not found, alert the user and pop the view controller
            let alert = UIAlertController(title: "Course not found", message: "Data for the course you selected was not found. Please select a different course.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.navigationController?.popViewController(animated: true) }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Course conditions functions
    
    // Display an alert allowing the user to choose a course condition and update the course with the selection
    @IBAction func updateCourseConditionsButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Current conditions", message: "Please select the current conditions for this course.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Good", style: .default, handler: { [self] action in
            selectedCourse.currentConditions = .good
            saveChanges()
        }))
        alert.addAction(UIAlertAction(title: "Fair", style: .default, handler: { [self] action in
            selectedCourse.currentConditions = .fair
            saveChanges()
        }))
        alert.addAction(UIAlertAction(title: "Caution", style: .default, handler: { [self] action in
            selectedCourse.currentConditions = .caution
            saveChanges()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // Save the updated course condition to UserDefaults and the courses array in CoursesViewController, and then update the courseConditions UI
    func saveChanges() {
        saveCourseData(courses: courses)
        delegate?.updateCoursesArray(courses: courses)
        updateCourseConditionsUI()
    }
    
    // Set the appropriate background color and text for the selected course conditions
    func updateCourseConditionsUI() {
        courseConditionsView.backgroundColor = selectedCourse.currentConditions.color
        courseConditionsLabel.text = selectedCourse.currentConditions.description
    }
    
    // MARK: - Table view data source
    
    // Number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    // Number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Cell for row at
    // Determine which TableViewCell to use and configure it
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // If in section 3, use the LayoutTableViewCell nib and set up UI elements for LayoutTableViewCell
        if indexPath.section == 3 {
            let layoutCell = tableView.dequeueReusableCell(withIdentifier: "LayoutCell", for: indexPath) as! LayoutTableViewCell
            
            layoutCell.numberOfHolesLabel.text = "18" + " holes"
            layoutCell.parTotalLabel.text = "Par " + "54"
            layoutCell.totalCourseDistanceLabel.text = "5400" + "ft"
            
            let layout = selectedCourse.layout
            
            for index in layout.holes {
                let holeNumberLabel = layoutCell.viewWithTag(index) as! UILabel
                holeNumberLabel.text = String(layout.holes[index - 1])
                
                let holeDistanceLabel = layoutCell.viewWithTag(index + 100) as! UILabel
                holeDistanceLabel.text = String(layout.holeDistance[index - 1])
                
                let holeParLabel = layoutCell.viewWithTag(index + 200) as! UILabel
                holeParLabel.text = String(layout.holePar[index - 1])
            }
            
            return layoutCell
        } else {
            // If not, use the cell configured in Interface Builder
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
}
