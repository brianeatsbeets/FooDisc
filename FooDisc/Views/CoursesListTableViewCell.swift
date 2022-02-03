//
//  CoursesListTableViewCell.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 2/2/22.
//

import UIKit

class CoursesListTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var conditionsLabelView: UIView!
    @IBOutlet var conditionsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        conditionsLabelView.layer.cornerRadius = 5
    }
    
}
