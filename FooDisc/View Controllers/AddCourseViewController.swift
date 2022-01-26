//
//  AddCourseViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/25/22.
//

import UIKit

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
    
    // TODO: create Course object
    // TODO: verify that this IBAction is the best way to handle saving Course and navigating back to courses view (maybe unwind stuff?)
    @IBAction func doneButtonPressed(_ sender: Any) {
        
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
