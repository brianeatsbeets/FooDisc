//
//  AddCourseTableViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/27/22.
//

import UIKit

// TODO: Comment code, implement text validation/save button enabling, and course creation/saving
class AddCourseTableViewController: UITableViewController {
    
    @IBOutlet var latitudeTextField: UITextField!
    @IBOutlet var longitudeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func latitudePolarityButtonPressed(_ sender: Any) {
        guard let currentText = latitudeTextField.text else {
            return
        }
        
        if currentText.hasPrefix("-") {
            let offsetIndex = currentText.index(currentText.startIndex, offsetBy: 1)
            let substring = currentText[offsetIndex...]  //remove first character
            latitudeTextField.text = String(substring)
        }
        else {
            latitudeTextField.text = "-" + currentText
        }
    }
    
    @IBAction func longitudePolarityButtonPressed(_ sender: Any) {
        guard let currentText = longitudeTextField.text else {
            return
        }
        
        if currentText.hasPrefix("-") {
            let offsetIndex = currentText.index(currentText.startIndex, offsetBy: 1)
            let substring = currentText[offsetIndex...]  //remove first character
            longitudeTextField.text = String(substring)
        }
        else {
            longitudeTextField.text = "-" + currentText
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
