//
//  CourseView.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/31/22.
//

import UIKit
import MapKit

// TODO: add custom support for delayed clustering (https://stackoverflow.com/questions/46827353/mkmap-ios11-clusters-doesnt-split-up-after-max-zoom-how-to-set-it-up)
// This class/annotation view displays a customizedCourseCalloutView
class CourseView: MKAnnotationView {
    
    // Override the default annotation variable with our own implementation
    override var annotation: MKAnnotation? {
        willSet {
            // Only want to customize annotation for Course annotations
            guard let course = newValue as? Course else { return }
            
            // Allow callout display
            canShowCallout = true
            
            // Load custom callout from nib
            let courseCalloutView = Bundle.main.loadNibNamed("CourseCalloutView", owner: self, options: nil)?.first as! CourseCalloutView
            
            // Validate that we have a distance from user for the course
            if let distance = course.distanceFromUser {
                courseCalloutView.locationLabel.text = course.city + ", " + course.state + " - " + String(distance) + "mi"
            } else {
                courseCalloutView.locationLabel.text = course.city + ", " + course.state
                print("Distance from user for course \(String(describing: course.title)) is nil")
            }
            
            courseCalloutView.conditionsLabel.text = String(describing: course.currentConditions)
            courseCalloutView.conditionsLabelView.backgroundColor = course.currentConditions.color
            
            // Set custom callout
            detailCalloutAccessoryView = courseCalloutView
            
            // Use a custom image in place of the default annotation marker
            image = UIImage(named: "courseIcon.png")
            
            // Set the annotation to always display, regardless of proximity to other annotations
            displayPriority = .required
        }
    }
    
}
