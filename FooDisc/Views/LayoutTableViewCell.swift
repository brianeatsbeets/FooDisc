//
//  LayoutTableViewCell.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 2/3/22.
//

import UIKit

// Custom cell to present the course layout
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
