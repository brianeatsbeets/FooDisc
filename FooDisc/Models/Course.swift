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
    
    // Init for sample data
    init(title: String, city: String, state: String, coordinate: CLLocationCoordinate2D, currentConditions: CourseCondition) {
        id = UUID().uuidString
        self.title = title
        self.city = city
        self.state = state
        self.coordinate = coordinate
        self.currentConditions = currentConditions
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
    
    // Generate a sample list of courses in Columbus, Ohio
    static func loadColumbusData() -> [Course] {
        let columbusCourses = [
            Course(title: "Griggs Reservoir Park DGC", city: "Columbus", state: "Ohio", coordinate: CLLocationCoordinate2D(latitude: 40.006890, longitude: -83.085640), currentConditions: .good),
            Course(title: "Ohio State University DGC", city: "Columbus", state: "Ohio", coordinate: CLLocationCoordinate2D(latitude: 40.001400, longitude: -83.036200), currentConditions: .caution),
            Course(title: "Veterans Memorial DGC", city: "Hilliard", state: "Ohio", coordinate: CLLocationCoordinate2D(latitude: 40.029979, longitude: -83.173121), currentConditions: .fair),
            Course(title: "Worthington Flats DGC", city: "Worthington", state: "Ohio", coordinate: CLLocationCoordinate2D(latitude: 40.092189, longitude: -83.032070), currentConditions: .good),
            Course(title: "Balgriffin Park", city: "Dublin", state: "Ohio", coordinate: CLLocationCoordinate2D(latitude: 40.084747, longitude: -83.153497), currentConditions: .good),
            Course(title: "Grove City Community Disc Golf Course", city: "Grove City", state: "Ohio", coordinate: CLLocationCoordinate2D(latitude: 39.864507, longitude: -83.067799), currentConditions: .good),
            Course(title: "Community Park", city: "Whitehall", state: "Ohio", coordinate: CLLocationCoordinate2D(latitude: 39.981808, longitude: -82.868446), currentConditions: .good),
            Course(title: "Area 51 DGC", city: "Obetz", state: "Ohio", coordinate: CLLocationCoordinate2D(latitude: 39.869211, longitude: -82.969104), currentConditions: .caution),
            Course(title: "Blendon Woods DGC", city: "Columbus", state: "Ohio", coordinate: CLLocationCoordinate2D(latitude: 40.077368, longitude: -82.888282), currentConditions: .good),
            Course(title: "Scioto Grove DGC", city: "Grove City", state: "Ohio", coordinate: CLLocationCoordinate2D(latitude: 39.843739, longitude: -83.025434), currentConditions: .caution),
            Course(title: "Brent Hambrick Memorial DGC", city: "Westerville", state: "Ohio", coordinate: CLLocationCoordinate2D(latitude: 40.108294, longitude: -82.877363), currentConditions: .good),
            Course(title: "Walnut Hill", city: "Columbus", state: "Ohio", coordinate: CLLocationCoordinate2D(latitude: 39.937859, longitude: -82.837311), currentConditions: .good),
            Course(title: "Glacier Ridge Metro Park", city: "Plain City", state: "Ohio", coordinate: CLLocationCoordinate2D(latitude: 40.154515, longitude: -83.193751), currentConditions: .fair),
            Course(title: "Alum Creek State Park DGC", city: "Lewis Center", state: "Ohio", coordinate: CLLocationCoordinate2D(latitude: 40.199568, longitude: -82.948013), currentConditions: .caution),
            Course(title: "Simsbury DGC", city: "Pickerington", state: "Ohio", coordinate: CLLocationCoordinate2D(latitude: 39.880840, longitude: -82.736488), currentConditions: .good),
            Course(title: "Lobdell Reserve", city: "Alexandria", state: "Ohio", coordinate: CLLocationCoordinate2D(latitude: 40.104198, longitude: -82.599998), currentConditions: .good)
        ]
        
        return columbusCourses
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
