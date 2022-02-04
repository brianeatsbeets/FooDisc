//
//  UtilityFunctions.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 2/4/22.
//

import Foundation

func fetchCourseData() -> [Course] {
    let defaults = UserDefaults.standard
    var courses: [Course] = []

    // Fetch courses array
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

func saveCourseData(courses: [Course]) {
    let defaults = UserDefaults.standard
    
    do {
        let encoder = JSONEncoder()
        let data = try encoder.encode(courses)
        defaults.set(data, forKey: "Courses")
    } catch {
        print("Failed to encode courses: \(error)")
    }
}
