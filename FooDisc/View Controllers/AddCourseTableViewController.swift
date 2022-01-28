//
//  AddCourseTableViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/27/22.
//

import UIKit
import MapKit

// TODO: course creation/saving, passing course id back to CoursesViewController and then navigating to CourseDetailViewCOntroller
class AddCourseTableViewController: UITableViewController {
    
    @IBOutlet var courseNameTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var stateTextField: UITextField!
    @IBOutlet var numberOfHolesTextField: UITextField!
    @IBOutlet var latitudeTextField: UITextField!
    @IBOutlet var longitudeTextField: UITextField!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    // Used to bulk-add event listeners
    var textFields: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeForm()
    }
    
    // MARK: Form initialization functions
    
    func initializeForm() {
        // Disable save button until all fields are filled in
        saveButton.isEnabled = false

        // Add listener for textField validation
        textFields = [courseNameTextField, cityTextField, stateTextField, numberOfHolesTextField, latitudeTextField, longitudeTextField]
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
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        saveNewCourse()
        //self.navigationController?.popViewController(animated: true)
    }
    
    // TODO: refresh map/table view controllers
    // Save course in UserDefaults
    func saveNewCourse() {
        let courseName = courseNameTextField.text!
        let city = cityTextField.text!
        let state = stateTextField.text!
        let numberOfHoles = Int(numberOfHolesTextField.text!)!
        let latitude = Double(latitudeTextField.text!)!
        let longitude = Double(longitudeTextField.text!)!
        
        let newCourse = Course(name: courseName, city: city, state: state, latitude: latitude, longitude: longitude, numberOfHoles: numberOfHoles)
        
        let defaults = UserDefaults.standard
        if var courses = defaults.object(forKey: "Courses") as? [Course] {
            courses.append(newCourse)
            defaults.set(newCourse, forKey: "Courses")
            print("Successfully saved new course to UserDefaults")
        } else {
            print("Error saving new course to UserDefaults")
        }
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
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

}
