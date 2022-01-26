//
//  Course.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/25/22.
//

import Foundation
import UIKit

class Course: NSObject {

    var name: String
    var city: String
    var state: String
    var distanceFromCurrentLocation: Double
    var numberOfHoles: Int
    var currentConditions: CourseCondition
    //var numberOfTimesPlayed: Int
    //var averageRating: Double
    
    init(name: String, city: String, state: String, distanceFromCurrentLocation: Double, numberOfHoles: Int, currentConditions: CourseCondition) {
        self.name = name
        self.state = state
        self.city = city
        self.distanceFromCurrentLocation = distanceFromCurrentLocation
        self.numberOfHoles = numberOfHoles
        self.currentConditions = currentConditions
        
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
