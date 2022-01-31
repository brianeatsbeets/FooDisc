//
//  Course.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/25/22.
//

import Foundation
import MapKit

private let defaultLayout = [1: 300, 2:300, 3:300, 4:300, 5:300, 6: 300, 7:300, 8:300, 9:300, 10:300, 11: 300, 12:300, 13:300, 14:300, 15:300, 16: 300, 17:300, 18:300]

// Course class to hold course data
// TODO: deal with encoding/decoding errors
class Course: NSObject, Codable, MKAnnotation {
    
    var id: String
    var name: String
    var title: String? { // Required for annotation
        return name
    }
    var city: String
    var state: String
    var coordinate: CLLocationCoordinate2D
    var currentConditions: CourseCondition
    var layout: [Int:Int]
    
    // Standard init
    init(name: String, city: String, state: String, coordinate: CLLocationCoordinate2D) {
        id = UUID().uuidString
        self.name = name
        self.city = city
        self.state = state
        self.coordinate = coordinate
        currentConditions = .good
        layout = defaultLayout
    }
    
    // Specify keys for encoding/decoding
    enum CodingKeys: String, CodingKey {
        case id, name, city, state, coordinate, currentConditions, layout, latitude, longitude
    }
    
    // Decoding initializer for a Course object and its properties
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? "Error"
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? "Error"
        city = try values.decodeIfPresent(String.self, forKey: .city) ?? "Error"
        state = try values.decodeIfPresent(String.self, forKey: .state) ?? "Error"
        currentConditions = try values.decode(CourseCondition.self, forKey: .currentConditions)
        layout = try values.decode([Int:Int].self, forKey: .layout)
        
        let latitude = try values.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try values.decode(CLLocationDegrees.self, forKey: .longitude)
        
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // Encode a Course object and its properties
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(state, forKey: .state)
        try container.encodeIfPresent(currentConditions, forKey: .currentConditions)
        try container.encodeIfPresent(layout, forKey: .layout)
        
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
}

// Enum to describe the current conditions of the Course
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


