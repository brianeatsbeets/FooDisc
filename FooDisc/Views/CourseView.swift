//
//  CourseView.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/31/22.
//

import UIKit
import MapKit

// TODO: (low priority) add custom support for delayed clustering (https://stackoverflow.com/questions/46827353/mkmap-ios11-clusters-doesnt-split-up-after-max-zoom-how-to-set-it-up)
class CourseView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            // Only want to customize annotation for Course annotations
            guard let course = newValue as? Course else { return }
            
            canShowCallout = true
            
            let courseCalloutView = Bundle.main.loadNibNamed("CourseCalloutView", owner: self, options: nil)?.first as! CourseCalloutView
            courseCalloutView.locationLabel.text = course.city + ", " + course.state + " - " + String(course.distanceFromUser) + "mi"
            courseCalloutView.conditionsLabel.text = String(describing: course.currentConditions)
            courseCalloutView.conditionsLabelView.backgroundColor = course.currentConditions.color
            
            detailCalloutAccessoryView = courseCalloutView
            
            // Use a custom image in place of the default annotation marker
            image = UIImage(named: "courseIcon.png")
            
            displayPriority = .required
        }
    }
    
}
