//
//  AddCourseTableViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/27/22.
//

import UIKit

// TODO: Comment code, implement text validation/min-number minus sign removal/save button enabling, course creation/saving, passing course id back to CoursesViewController and then navigating to CourseDetailViewCOntroller
class AddCourseTableViewController: UITableViewController {
    
    @IBOutlet var latitudeTextField: UITextField!
    @IBOutlet var longitudeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
