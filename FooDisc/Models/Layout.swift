//
//  Layout.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 2/3/22.
//

import Foundation

// TODO: allow creation of custom layouts (18-hole, then others if time)
// This struct provides a custom object to contain course layout information
struct Layout: Codable {
    let holes: [Int]
    let holeDistance: [Int]
    let holePar: [Int]
    
    // Layouts currently hold dummy data
    init() {
        holes = Array(1...18)
        holeDistance = [Int](repeating: 300, count: 18)
        holePar = [Int](repeating: 3, count: 18)
    }
}
