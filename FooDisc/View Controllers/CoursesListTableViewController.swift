//
//  CoursesListTableViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/26/22.
//

import UIKit

class CoursesListTableViewController: UITableViewController {
    
    // Reload table when new data is present
    var courses : [Course] = [] {
        didSet {
            tableView.reloadData()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CoursesListTableViewCell", bundle: nil), forCellReuseIdentifier: "CoursesListTableViewCell")
    }

    // MARK: - Table view data source

    // Number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    // Cell for row at
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoursesListTableViewCell", for: indexPath) as! CoursesListTableViewCell
        let course = courses[indexPath.row]
        
        cell.nameLabel.text = course.name
        cell.locationLabel.text = course.city + ", " + course.state + " - " + String(course.distanceFromUser) + "mi"
        cell.conditionsLabel.text = String(describing: course.currentConditions)
        cell.conditionsLabelView.backgroundColor = course.currentConditions.color

        return cell
    }
}
