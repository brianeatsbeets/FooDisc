//
//  Scorecard.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 2/5/22.
//

import Foundation

// This struct provides a custom object with which to create and store scorecard data
struct Scorecard: Codable {
    
    let course: Course
    var scorePerHole: [Int]
    let date: Date
    var totalScore: Int
    var totalPar: Int
    var isScorecardComplete: Bool
    
    init(course: Course) {
        self.course = course
        scorePerHole = [Int](repeating: 0, count: 18)
        date = Date()
        totalScore = 0
        totalPar = 0
        isScorecardComplete = true
    }
    
    // MARK: Data storage/retrieval functions
    
    // Retrieve scorecard data from UserDefaults
    static func fetchScorecardData() -> [Scorecard] {
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
    static func saveScorecardData(scorecards: [Scorecard]) {
        let defaults = UserDefaults.standard
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(scorecards)
            defaults.set(data, forKey: "Scorecards")
        } catch {
            print("Failed to encode scorecards: \(error)")
        }
    }
}
