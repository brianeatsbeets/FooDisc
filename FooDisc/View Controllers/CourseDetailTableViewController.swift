//
//  CourseDetailTableViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 2/3/22.
//

import UIKit
import MapKit

// TODO: display a separate highlight background color for button presses
// This class/table view controller provides a table view that lists course details of a selected course
class CourseDetailTableViewController: UITableViewController, MKMapViewDelegate {
    
    // MARK: Variable declarations
    
    @IBOutlet var courseTitleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var distanceFromUserLabel: UILabel!
    @IBOutlet var courseDetailMapView: MKMapView!
    @IBOutlet var courseConditionsView: UIView!
    @IBOutlet var courseConditionsLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    var courses: [Course]
    var selectedCourse: Course
    
    // Set up a CoursesDelegate instance so we can talk to CoursesViewController
    weak var delegate: CoursesDelegate?
    
    // MARK: Initializers
    
    // Custom initializer to set courses array
    init?(coder: NSCoder, courses: [Course], selectedCourse: Course) {
        self.courses = courses
        self.selectedCourse = selectedCourse
        super.init(coder: coder)
    }
    
    // Required initializer as a subclass of UIViewController
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Class functions
    
    // Set up table view, grab selected course, and configure UI elements
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // Register CourseView class as the default annotation view reuse identifier
        mapView.register(CourseView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        tableView.register(UINib(nibName: "LayoutTableViewCell", bundle: nil), forCellReuseIdentifier: "LayoutCell")
        courseConditionsView.layer.cornerRadius = 5
        
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
        initializeMapView()
    }
    
    // Initialize the mapView according to the selected course
    func initializeMapView() {
        // Zoom map to course region
        let region = MKCoordinateRegion(center: selectedCourse.coordinate, latitudinalMeters: 2500, longitudinalMeters: 2500)
        mapView.setRegion(region, animated: false)
        
        // Add selected course annotation
        mapView.addAnnotation(selectedCourse)
        
        // Disable user interaction
        mapView.isUserInteractionEnabled = false
    }
    
    // Open driving directions to course in Apple Maps
    @IBAction func getDirectionsButtonTapped(_ sender: Any) {
        
        // Create an MKPlacemark, then create an MKMapItem with it
        let placemark = MKPlacemark(coordinate: selectedCourse.coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = selectedCourse.title
        
        // Set Apple Maps launch options to driving directions
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        
        // Open map item in Apple Maps
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentScorecardViewController" {
            guard let viewController = segue.destination as? ScorecardViewController else { return }
            viewController.selectedCourse = selectedCourse
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
            
            layoutCell.numberOfHolesLabel.text = "\(selectedCourse.layout.holes.count) holes"
            layoutCell.parTotalLabel.text = "Par \(selectedCourse.layout.holePar.reduce(0, +))"
            layoutCell.totalCourseDistanceLabel.text = "\(selectedCourse.layout.holeDistance.reduce(0, +))ft"
            
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
