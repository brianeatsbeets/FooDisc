//
//  AddCourseViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/25/22.
//

// TODO: add keyboard view adjustment/dismissal

import UIKit

class AddCourseViewController: UIViewController {

    @IBOutlet var courseNameTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var stateTextField: UITextField!
    @IBOutlet var numberOfHolesTextField: UITextField!
    @IBOutlet var latitudeTextField: UITextField!
    @IBOutlet var longitudeTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    var textFields: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.isEnabled = false

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
                break
            }
            if textField == textFields.last {
                submitButton.isEnabled = true
            }
        }
    }
    
    // TODO: create Coure object
    // TODO: verify that this IBAction is the best way to handle saving Course and navigating back to courses view (maybe unwind stuff?)
    @IBAction func submitButtonPressed(_ sender: Any) {
        
    }
    
}
