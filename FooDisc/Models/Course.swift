//
//  Course.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/25/22.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

// Course class to hold course data
// TODO: Update comments
class Course {
    var name: String?
    var city: String?
    var state: String?
    //var latitude: Double
    //var longitude: Double
    var coordinate: CLLocationCoordinate2D
    var numberOfHoles: Int?
    var currentConditions: CourseCondition
    var layout: [Int:Int]
    
    init(name: String, city: String, state: String, latitude: Double, longitude: Double, numberOfHoles: Int) {
        self.name = name
        self.city = city
        self.state = state
        //self.latitude = latitude
        //self.longitude = longitude
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        currentConditions = .good
        layout = defaultLayout
    }
}

enum CourseCondition: Codable {
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

private let defaultLayout = [1: 300, 2:300, 3:300, 4:300, 5:300, 6: 300, 7:300, 8:300, 9:300, 10:300, 11: 300, 12:300, 13:300, 14:300, 15:300, 16: 300, 17:300, 18:300]
