//
//  CoursesListTableViewCell.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 2/2/22.
//

import UIKit

// This class/table view cell provides a custom cell for course information to be displayed in CoursesListTableViewController
class CoursesListTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var conditionsLabelView: UIView!
    @IBOutlet var conditionsLabel: UILabel!
    
    // Configure UI elements on initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        conditionsLabelView.layer.cornerRadius = 5
    }
    
}
