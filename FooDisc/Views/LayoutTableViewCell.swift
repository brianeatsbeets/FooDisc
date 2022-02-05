//
//  LayoutTableViewCell.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 2/3/22.
//

import UIKit

// This class/table view cell provides a custom cell for course layout information to be displayed in CoursesDetailTableViewController
class LayoutTableViewCell: UITableViewCell {
    
    @IBOutlet var numberOfHolesLabel: UILabel!
    @IBOutlet var parTotalLabel: UILabel!
    @IBOutlet var totalCourseDistanceLabel: UILabel!
    @IBOutlet var holeNumberLabel: [UILabel]!
    @IBOutlet var holeDistanceLabel: [UILabel]!
    @IBOutlet var holeParLabel: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
