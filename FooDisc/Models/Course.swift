//
//  Course.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/25/22.
//

import Foundation
import MapKit

// TODO: allow creation of custom layouts (18-hole, then others if time)
// TODO: deal with potential encoding/decoding errors
// Course class to hold course data
class Course: NSObject, Codable, MKAnnotation {
    
    var id: String
    var title: String? // Required by MKAnnotation
    var city: String
    var state: String
    var coordinate: CLLocationCoordinate2D
    var currentConditions: CourseCondition
    var layout = Layout()
    var distanceFromUser: Double?
    
    // Standard init
    init(title: String, city: String, state: String, coordinate: CLLocationCoordinate2D) {
        id = UUID().uuidString
        self.title = title
        self.city = city
        self.state = state
        self.coordinate = coordinate
        currentConditions = .good
        //layout = defaultLayout
        distanceFromUser = 0
    }
    
    // Initialize empty course
    convenience override init() {
        self.init(title: "", city: "", state: "", coordinate: CLLocationCoordinate2D())
    }
    
    // MARK: Codable conforming elements
    
    // TODO: add layout when layouts are configurable
    // Specify keys for encoding/decoding
    enum CodingKeys: String, CodingKey {
        case id, title, city, state, coordinate, currentConditions, latitude, longitude
    }
    
    // TODO: read up on decodeIfPresent vs. decode
    // Decoding initializer for a Course object and its properties
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? "Error"
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? "Error"
        city = try values.decodeIfPresent(String.self, forKey: .city) ?? "Error"
        state = try values.decodeIfPresent(String.self, forKey: .state) ?? "Error"
        currentConditions = try values.decode(CourseCondition.self, forKey: .currentConditions)
        //layout = defaultLayout
        distanceFromUser = 0
        
        let latitude = try values.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try values.decode(CLLocationDegrees.self, forKey: .longitude)
        
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // TODO: read up on encodeIfPresent vs. encode
    // Encode a Course object and its properties
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(state, forKey: .state)
        try container.encodeIfPresent(currentConditions, forKey: .currentConditions)
        
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
}

// Enum to describe the current conditions of the Course
enum CourseCondition: Codable, CustomStringConvertible {
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
    
    var description: String {
        switch self {
        case .caution:
            return "Caution"
        case .fair:
            return "Fair Conditions"
        case .good:
            return "Good Conditions"
        }
    }
}


