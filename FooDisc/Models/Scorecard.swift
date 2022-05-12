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
    
    // Init for use with sample data
    init(course: Course, date: Date, totalScore: Int, totalPar: Int) {
        self.course = course
        scorePerHole = [Int](repeating: 0, count: 18)
        self.date = date
        self.totalScore = totalScore
        self.totalPar = totalPar
        
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
    
    // Generate a sample list of scorecards
    static func loadSampleScorecards() -> [Scorecard] {
        let scorecards = [
            Scorecard(course: Course.loadColumbusData()[12], date: Date(), totalScore: 44, totalPar: -3),
            Scorecard(course: Course.loadColumbusData()[1], date: Date(), totalScore: 49, totalPar: -1),
            Scorecard(course: Course.loadColumbusData()[1], date: Date(), totalScore: 52, totalPar: 2),
            Scorecard(course: Course.loadColumbusData()[3], date: Date(), totalScore: 57, totalPar: 0),
            Scorecard(course: Course.loadColumbusData()[4], date: Date(), totalScore: 52, totalPar: -1),
            Scorecard(course: Course.loadColumbusData()[4], date: Date(), totalScore: 51, totalPar: -2),
            Scorecard(course: Course.loadColumbusData()[6], date: Date(), totalScore: 65, totalPar: 4),
            Scorecard(course: Course.loadColumbusData()[5], date: Date(), totalScore: 46, totalPar: -6),
            Scorecard(course: Course.loadColumbusData()[8], date: Date(), totalScore: 49, totalPar: -3),
            Scorecard(course: Course.loadColumbusData()[8], date: Date(), totalScore: 48, totalPar: -4),
            Scorecard(course: Course.loadColumbusData()[10], date: Date(), totalScore: 61, totalPar: 1),
            Scorecard(course: Course.loadColumbusData()[1], date: Date(), totalScore: 49, totalPar: -1),
            Scorecard(course: Course.loadColumbusData()[12], date: Date(), totalScore: 49, totalPar: 2)
        ]
        
        return scorecards
    }
}
