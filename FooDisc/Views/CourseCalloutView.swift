//
//  CourseCalloutView.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 2/1/22.
//

import UIKit

// TODO: limit view width and have long titles wrap
// This class/view provides a custom view for course information to be displayed on the annotation callout
class CourseCalloutView: UIView {
    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var conditionsLabelView: UIView!
    @IBOutlet var conditionsLabel: UILabel!

    // Configure UI elements on initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        conditionsLabelView.layer.cornerRadius = 5
    }
}
