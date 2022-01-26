//
//  Course.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/25/22.
//

import Foundation
import UIKit
import CoreLocation

// Course class to hold course data
// TODO: Is this necessary with the addition of Core Data Entities?
class Course: Codable {

    var name: String
    var city: String
    var state: String
    var latitude: Double
    var longitude: Double
    var numberOfHoles: Int
    var distanceFromCurrentLocation: Double
    //var currentConditions: CourseCondition
    var numberOfTimesPlayed: Int
    var averageRating: Double
    
    init(name: String, city: String, state: String, latitude: Double, longitude: Double, numberOfHoles: Int) {
        self.name = name
        self.state = state
        self.city = city
        self.latitude = latitude
        self.longitude = longitude
        self.numberOfHoles = numberOfHoles
        self.distanceFromCurrentLocation = 0
        //self.currentConditions = .good
        self.numberOfTimesPlayed = 0
        self.averageRating = 0
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
        }
    }
}
