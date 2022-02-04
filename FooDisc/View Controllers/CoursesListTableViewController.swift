//
//  CoursesListTableViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/26/22.
//

import UIKit

// TODO: sort by distance
// TODO: (if time) filter courses
class CoursesListTableViewController: UITableViewController {
    
    // Reload table when new data is present
    var courses : [Course] = [] {
        didSet {
            tableView.reloadData()
            print("Reloading Courses List TableView data")
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
        
        cell.nameLabel.text = course.title
        
        // Validate that we have a distance from user for the course
        if let distance = course.distanceFromUser {
            cell.locationLabel.text = course.city + ", " + course.state + " - " + String(distance) + "mi"
        } else {
            cell.locationLabel.text = course.city + ", " + course.state
            print("Distance from user for course \(String(describing: course.title)) is nil")
        }
        
        cell.conditionsLabel.text = String(describing: course.currentConditions)
        cell.conditionsLabelView.backgroundColor = course.currentConditions.color

        return cell
    }
    
    // Did select row at
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "CourseDetailTableViewController") as? CourseDetailTableViewController else { return }
        viewController.selectedCourse = courses[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}
