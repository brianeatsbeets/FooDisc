//
//  CourseCalloutView.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 2/1/22.
//

import UIKit

class CourseCalloutView: UIView {
    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var conditionsLabelView: UIView!
    @IBOutlet var conditionsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        conditionsLabelView.layer.cornerRadius = 5
    }
}
