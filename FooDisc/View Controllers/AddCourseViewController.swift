//
//  AddCourseViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/25/22.
//

import UIKit
import CoreLocation
import CoreData

class AddCourseViewController: UIViewController {

    @IBOutlet var courseNameTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var stateTextField: UITextField!
    @IBOutlet var numberOfHolesTextField: UITextField!
    @IBOutlet var latitudeTextField: UITextField!
    @IBOutlet var longitudeTextField: UITextField!
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var scrollView: UIScrollView!
    
    var textFields: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeForm()
    }
    
    // Create and save new course, then navigate back to CoursesViewController
    @IBAction func doneButtonPressed(_ sender: Any) {
        saveNewCourse()
        deregisterForKeyboardNotifications()
        self.navigationController?.popViewController(animated: true)
    }
    
    // Save new course in Core Data
    // Force unwrapping here because we are validating for non-empty textfields and Int/Double inputs use the number/decimal keyboard respectively
    func saveNewCourse() {
        let courseName = courseNameTextField.text!
        let city = cityTextField.text!
        let state = stateTextField.text!
        let numberOfHoles = Int(numberOfHolesTextField.text!)!
        let latitude = Double(latitudeTextField.text!)!
        let longitude = Double(longitudeTextField.text!)!
        
        //let newCourse = Course(name: courseName, city: city, state: state, latitude: latitude, longitude: longitude, numberOfHoles: numberOfHoles) // Standard class object creation
        
        // MARK: Entity Core Data implementation
        // Initialize appDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Error setting app delegate")
            return
        }

        // Set up the staging area for saving managed objects
        let managedContext = appDelegate.persistentContainer.viewContext

        // Insert a new managed object into the staging area
        let entity = NSEntityDescription.entity(forEntityName: "CourseEntity", in: managedContext)!
        let newCourse = NSManagedObject(entity: entity, insertInto: managedContext)

        // Set the properties of the managed object
        newCourse.setValue(courseName, forKeyPath: "name")
        newCourse.setValue(city, forKeyPath: "city")
        newCourse.setValue(state, forKeyPath: "state")
        newCourse.setValue(numberOfHoles, forKeyPath: "numberOfHoles")
        newCourse.setValue(latitude, forKeyPath: "latitude")
        newCourse.setValue(longitude, forKeyPath: "longitude")

        // Attempt to save the managed object to the disk
        do {
            try managedContext.save()
            print("Attempted save")
        } catch let error as NSError {
            print("Error saving managed object to disk. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: Form initialization functions
    
    func initializeForm() {
        // Disable done button until all fields are filled in
        doneButton.isEnabled = false
        
        // Add listener for keyboard notifications
        registerForKeyboardNotifications()

        // Add listener for textField validation
        textFields = [courseNameTextField, cityTextField, stateTextField, numberOfHolesTextField, latitudeTextField, longitudeTextField]
        for textField in textFields {
          textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    // Check if all textFields have text, and if so, enable the submit button
    @objc func textFieldDidChange(_ textField: UITextField) {
        for textField in textFields {
            if !textField.hasText {
                if doneButton.isEnabled {
                    doneButton.isEnabled = false
                }
                break
            }
            if textField == textFields.last {
                doneButton.isEnabled = true
            }
        }
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(_ notificiation: NSNotification) {
        guard let info = notificiation.userInfo, let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0,
        bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(_ notification:
       NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
}
