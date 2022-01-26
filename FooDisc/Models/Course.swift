//
//  Course.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/25/22.
//

import Foundation
import UIKit
import CoreLocation

class Course: NSObject {

    var name: String
    var city: String
    var state: String
    var location: CLLocation
    var numberOfHoles: Int
    var distanceFromCurrentLocation: Double
    var currentConditions: CourseCondition
    //var numberOfTimesPlayed: Int
    //var averageRating: Double
    
    init(name: String, city: String, state: String, location: CLLocation, numberOfHoles: Int) {
        self.name = name
        self.state = state
        self.city = city
        self.location = location
        self.numberOfHoles = numberOfHoles
        self.distanceFromCurrentLocation = 0
        self.currentConditions = .good
        
        super.init()
    }
    
}

enum CourseCondition {
    case caution, fair, good
    
    var color: UIColor {
        switch self {
        case .caution:
            return .red
        case .fair:
            return .yellow
        case .good:
            return .green
        default:
            return .white
        }
    }
}
