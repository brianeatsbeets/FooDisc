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
            guard let courseAnnotation = newValue as? Course else { return }
            
            print("New custom annotation view here")
            //clusteringIdentifier = "course"
            
            canShowCallout = true
            //rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            //        // Create a custom button for annotation view right callout accessory
            //        let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 48, height: 48)))
            //        mapsButton.setBackgroundImage(#imageLiteral(resourceName: "Map"), for: .normal)
            //        rightCalloutAccessoryView = mapsButton
            
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
