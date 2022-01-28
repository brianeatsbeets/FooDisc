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
class Course: NSObject, MKAnnotation {
    var name: String?
    var city: String?
    var state: String?
    //var latitude: Double
    //var longitude: Double
    var coordinate: CLLocationCoordinate2D
    var numberOfHoles: Int?
    var distanceFromCurrentLocation: Double
    var currentConditions: CourseCondition
    var layout: [Int:Int]
    
    init(name: String, city: String, state: String, coordinate: CLLocationCoordinate2D, numberOfHoles: Int) {
        self.name = name
        self.city = city
        self.state = state
        //self.latitude = latitude
        //self.longitude = longitude
        self.coordinate = coordinate
        self.numberOfHoles = numberOfHoles
        distanceFromCurrentLocation = 0
        currentConditions = .good
        layout = [1: 300, 2:300, 3:300, 4:300, 5:300, 6: 300, 7:300, 8:300, 9:300, 10:300, 11: 300, 12:300, 13:300, 14:300, 15:300, 16: 300, 17:300, 18:300]
    }
    
    // Failable initializer that takes in an MKGeoJSONFeature (GeoJSON data) and maps it to a Course object
    init?(feature: MKGeoJSONFeature) {
        guard let point = feature.geometry.first as? MKPointAnnotation, // Define as point annotation (can also be a shape)
              let propertiesData = feature.properties,
              let json = try? JSONSerialization.jsonObject(with: propertiesData), // Decode JSON
              let properties = json as? [String: Any] // Map to a dictionary
        else { return nil }

        name = properties["name"] as? String
        city = properties["city"] as? String
        state = properties["state"] as? String
        coordinate = point.coordinate
        numberOfHoles = properties["number_of_holes"] as? Int
        distanceFromCurrentLocation = 0
        currentConditions = .good
        layout = [1: 300, 2:300, 3:300, 4:300, 5:300, 6: 300, 7:300, 8:300, 9:300, 10:300, 11: 300, 12:300, 13:300, 14:300, 15:300, 16: 300, 17:300, 18:300]

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
        }
    }
}
