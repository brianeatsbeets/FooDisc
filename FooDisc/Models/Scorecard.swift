//
//  Scorecard.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 2/5/22.
//

import Foundation

// This class provides a custom object with which to create and store scorecard data
class Scorecard: Codable {
    
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
}
