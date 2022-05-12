//
//  Course.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 1/25/22.
//

import Foundation
import MapKit

// TODO: deal with potential encoding/decoding errors?
// This class/annotation provides a custom object to contain course information
class Course: NSObject, Codable, MKAnnotation {
//class Course: NSObject, MKAnnotation {
    
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
        distanceFromUser = 0
    }
    
    // MARK: Data storage/retrieval functions
    
    // Retrieve course data from UserDefaults
    static func fetchCourseData() -> [Course] {
        let defaults = UserDefaults.standard
        var courses: [Course] = []

        if let data = defaults.data(forKey: "Courses") {
            do {
                let decoder = JSONDecoder()
                courses = try decoder.decode([Course].self, from: data)
            } catch {
                print("Failed to decode courses: \(error)")
            }
        }
        
        return courses
    }

    // Save course data to UserDefaults
    static func saveCourseData(courses: [Course]) {
        let defaults = UserDefaults.standard
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(courses)
            defaults.set(data, forKey: "Courses")
        } catch {
            print("Failed to encode courses: \(error)")
        }
    }
    
    // MARK: Codable conforming elements

    // TODO: add layout when layouts are configurable
    // Specify keys for encoding/decoding
    enum CodingKeys: String, CodingKey {
        case id, title, city, state, coordinate, currentConditions, latitude, longitude, layout
    }

    // Decoding initializer for a Course object and its properties
    required init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? "Error"
        city = try values.decode(String.self, forKey: .city)
        state = try values.decode(String.self, forKey: .state)
        currentConditions = try values.decode(CourseCondition.self, forKey: .currentConditions)
        layout = try values.decode(Layout.self, forKey: .layout)
        distanceFromUser = 0

        let latitude = try values.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try values.decode(CLLocationDegrees.self, forKey: .longitude)

        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    // Encode a Course object and its properties
    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encode(city, forKey: .city)
        try container.encode(state, forKey: .state)
        try container.encode(currentConditions, forKey: .currentConditions)
        try container.encode(layout, forKey: .layout)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
}

// MARK: Supporting types

// Enum to describe the current conditions of the Course
enum CourseCondition: Codable, CustomStringConvertible {
    case caution, fair, good
    
    var color: UIColor {
        switch self {
        case .caution:
            return UIColor(red: 0.596, green: 0.122, blue: 0.055, alpha: 1.0) // Red
        case .fair:
            return UIColor(red: 0.755, green: 0.712, blue: 0, alpha: 1.0) // Yellow
        case .good:
            return UIColor(red: 0.063, green: 0.404, blue: 0.227, alpha: 1.0) // Green
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
