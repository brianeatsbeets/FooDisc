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
            
            print("New course annotation view here")
            //clusteringIdentifier = "course"
            
            canShowCallout = true
            
            let courseCalloutView = Bundle.main.loadNibNamed("CourseCalloutView", owner: self, options: nil)?.first as! CourseCalloutView
            courseCalloutView.locationLabel.text = course.city + ", " + course.state
            courseCalloutView.conditionsLabel.text = String(describing: course.currentConditions)
            courseCalloutView.conditionsLabelView.backgroundColor = course.currentConditions.color
//            switch course.currentConditions {
//            case .caution:
//                courseCalloutView.conditionsLabel.text = "Caution"
//                courseCalloutView.conditionsLabel.backgroundColor = course.currentConditions.color
//            case .fair:
//                return "Fair Conditions"
//            case .good:
//                return "Good Conditions"
//            }
            
            detailCalloutAccessoryView = courseCalloutView
            
            // Use a custom image in place of the default annotation marker
            image = UIImage(named: "courseIcon.png")
            
            //        // Create a multi-line label for annotation view detail callout accessory
            //        let detailLabel = UILabel()
            //        detailLabel.numberOfLines = 0
            //        detailLabel.font = detailLabel.font.withSize(12)
            //        detailLabel.text = place.subtitle
            //        detailCalloutAccessoryView = detailLabel
            
            displayPriority = .required
        }
    }
    
}

//class CourseClusterView: MKAnnotationView {
//
//    override var annotation: MKAnnotation? {
//        didSet {
//            print("Cluster set")
//            print(annotation?.title)
//            if let annotation = annotation as? MKClusterAnnotation {
//                print(annotation.memberAnnotations.count)
//                image = UIImage(named: "clusterIcon.png")
//            } else {
//                print("Annotation isn't a cluster!")
//            }
//
//
//        }
//    }
//
//    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
//        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//
//        displayPriority = .init(0)
//        collisionMode = .circle
//
//        frame = CGRect(x: 0, y: 0, width: 40, height: 50)
//        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
