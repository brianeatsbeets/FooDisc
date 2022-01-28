//
//  CoursesListTableViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/26/22.
//

import UIKit

class CoursesListTableViewController: UITableViewController {
    
    var courses : [Course] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath)
        let course = courses[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = course.name
        content.secondaryText = "\(course.city), \(course.state)"
        cell.contentConfiguration = content

        return cell
    }
}
