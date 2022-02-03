//
//  CourseDetailTableViewController.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 2/3/22.
//

import UIKit
import MapKit

class CourseDetailTableViewController: UITableViewController {
    
    @IBOutlet var courseTitleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var distanceFromUserLabel: UILabel!
    @IBOutlet var courseDetailMapView: MKMapView!
    @IBOutlet var courseConditionsView: UIView!
    @IBOutlet var courseConditionsLabel: UILabel!
    
    var course = Course()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "LayoutTableViewCell", bundle: nil), forCellReuseIdentifier: "LayoutCell")
        courseConditionsView.layer.cornerRadius = 5
        
        initializeUI()
    }
    
    func initializeUI() {
        courseTitleLabel.text = course.title
        locationLabel.text = course.city + ", " + course.state
        
        // Validate that we have a distance from user for the course
        if let distance = course.distanceFromUser {
            distanceFromUserLabel.text = String(distance) + "mi"
        } else {
            distanceFromUserLabel.text = ""
            print("Distance from user for course \(String(describing: course.title)) is nil")
        }
        
        courseConditionsView.backgroundColor = course.currentConditions.color
        courseConditionsLabel.text = course.currentConditions.description
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Use the LayoutTableViewCell if in section 3
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 3 {
            let layoutCell = tableView.dequeueReusableCell(withIdentifier: "LayoutCell", for: indexPath) as! LayoutTableViewCell
            
            layoutCell.numberOfHolesLabel.text = "18" + " holes"
            layoutCell.parTotalLabel.text = "Par " + "54"
            layoutCell.totalCourseDistanceLabel.text = "5400" + "ft"
            
            let layout = course.layout
            
            for index in layout.holes {
                let holeNumberLabel = layoutCell.viewWithTag(index) as! UILabel
                holeNumberLabel.text = String(layout.holes[index - 1])
                
                let holeDistanceLabel = layoutCell.viewWithTag(index + 100) as! UILabel
                holeDistanceLabel.text = String(layout.holeDistance[index - 1])
                
                let holeParLabel = layoutCell.viewWithTag(index + 200) as! UILabel
                holeParLabel.text = String(layout.holePar[index - 1])
            }
            
            return layoutCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }

}
