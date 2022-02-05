//
//  AddCourseTableViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/27/22.
//

import UIKit
import CoreLocation

// TODO: add feedback/confirmation message after successfully adding a course
// TODO: change state textfield to UIPicker
// TODO: debug why initial tap into text field has delayed focus
// TODO: resolve "Can't find keyplane that supports type 8 for keyboard iPhone-PortraitChoco-DecimalPad; using 27100_PortraitChoco_iPhone-Simple-Pad_Default" error when using latitude/longitude text fields
class AddCourseTableViewController: UITableViewController {
    
    // MARK: Variable declarations
    
    @IBOutlet var courseNameTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var stateTextField: UITextField!
    @IBOutlet var latitudeTextField: UITextField!
    @IBOutlet var longitudeTextField: UITextField!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    var courses: [Course] = []
    
    // Set up a CoursesDelegate instance so we can talk to CoursesViewController
    weak var delegate: CoursesDelegate?
    
    // Used to bulk-add event listeners
    var textFields: [UITextField] = []
    
    // MARK: Class functions
    
    // Load up form
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeForm()
    }
    
    // MARK: Form initialization functions
    
    // Configure form elements
    func initializeForm() {
        // Disable save button until all fields are filled in
        saveButton.isEnabled = false

        // Add listener for textField validation
        textFields = [courseNameTextField, cityTextField, stateTextField, latitudeTextField, longitudeTextField]
        for textField in textFields {
          textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    // Check if all textFields have text, and if so, enable the save button
    @objc func textFieldDidChange(_ textField: UITextField) {
        for textField in textFields {
            if !textField.hasText {
                if saveButton.isEnabled {
                    saveButton.isEnabled = false
                }
                break
            }
            if textField == textFields.last {
                saveButton.isEnabled = true
            }
        }
    }
    
    // MARK: Button actions
    
    // Save new course and unwind to CoursesViewController
    @IBAction func saveButtonPressed(_ sender: Any) {
        saveNewCourse()
        navigationController?.popViewController(animated: true)
    }
    
    // Save course to UserDefaults and CoursesViewController courses array
    // Force unwrapping because of !.isEmpty validation along with coordinate fields using numerical/decimal keyboards
    func saveNewCourse() {
        let courseName = courseNameTextField.text!
        let city = cityTextField.text!
        let state = stateTextField.text!
        let latitude = Double(latitudeTextField.text!)!
        let longitude = Double(longitudeTextField.text!)!
        
        let newCourse = Course(title: courseName, city: city, state: state, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        
        // Add new course to existing courses array
        courses.append(newCourse)
        
        // Save to UserDefaults
        saveCourseData(courses: courses)
        
        // Save to delegate courses array
        delegate?.updateCoursesArray(courses: courses)
    }
    
    // Determine which polarity button was pressed and apply polarity to respective text field
    @IBAction func polarityButtonPressed(_ sender: UIButton) {
        var coordinateTextField: UITextField
        
        // Set appropriate text field
        switch sender.tag {
        case 1000:
            coordinateTextField = latitudeTextField
        case 2000:
            coordinateTextField = longitudeTextField
        default:
            return
        }
        
        // Unwrap text field for examination
        guard let currentText = coordinateTextField.text else {
            return
        }
        
        // If text field starts with -, chop it off. If not, add it
        if currentText.first == "-" {
            let offsetIndex = currentText.index(currentText.startIndex, offsetBy: 1)
            let substring = currentText[offsetIndex...]
            coordinateTextField.text = String(substring)
        }
        else {
            coordinateTextField.text = "-" + currentText
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
