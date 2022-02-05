//
//  UtilityFunctions.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 2/4/22.
//

import Foundation

// Retrieve course data from UserDefaults
func fetchCourseData() -> [Course] {
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

// Retrieve scorecard data from UserDefaults
func fetchScorecardData() -> [Scorecard] {
    let defaults = UserDefaults.standard
    var scorecards: [Scorecard] = []

    if let data = defaults.data(forKey: "Scorecards") {
        do {
            let decoder = JSONDecoder()
            scorecards = try decoder.decode([Scorecard].self, from: data)
        } catch {
            print("Failed to decode scorecards: \(error)")
        }
    }
    
    return scorecards
}

// Save scorecard data to UserDefaults
func saveScorecardData(scorecards: [Scorecard]) {
    let defaults = UserDefaults.standard
    
    do {
        let encoder = JSONEncoder()
        let data = try encoder.encode(scorecards)
        defaults.set(data, forKey: "Scorecards")
    } catch {
        print("Failed to encode scorecards: \(error)")
    }
}
