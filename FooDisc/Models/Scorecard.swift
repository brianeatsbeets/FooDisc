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
    var scorePerHole: [Int: Int]
    let date: Date
    let totalScore: Int
    let totalPar: Int
    
    init(course: Course) {
        self.course = course
        scorePerHole = [1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0, 8:0, 9:0, 10:0, 11:0, 12:0, 13:0, 14:0, 15:0, 16:0, 17:0, 18:0]
        date = Date()
        totalScore = 0
        totalPar = 0
    }
}
