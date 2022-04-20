//
//  Disc.swift
//  FooDisc
//
//  Created by Aguirre, Brian P. on 3/8/22.
//

import UIKit

// MARK: Main class implementation

// TODO: add support for multiple disc bags
// TODO: review Equatable implementation and compare to alternate implementations elsewhere in app
// TODO: utilize imageData route for encoding images elsewhere in app
// This struct provides a custom object to contain disc information
// Equatable conformance is used to compare discs when finishing editing a disc to replace the old version of it
struct Disc: Equatable, Codable {
    
    var id = UUID()
    var name: String
    @CodableColor var color: UIColor
    var imageData: Data?
    var type: DiscType
    var manufacturer: String
    var plastic: String
    var weightInGrams: Double
    var speed: Double
    var glide: Double
    var turn: Double
    var fade: Double
    var condition: Condition
    var notes: String?
    var inBag: Bool
    
    // Define archival directory
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("discs").appendingPathExtension("plist")
    
    // Equatable required function
    static func ==(lhs: Disc, rhs: Disc) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Load disc collection
    static func loadDiscs() -> [Disc]? {
        guard let codedDiscs = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Disc>.self, from: codedDiscs)
    }
    
    // Save disc collection
    static func saveDiscs(_ discs: [Disc]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedDiscs = try? propertyListEncoder.encode(discs)
        try? codedDiscs?.write(to: archiveURL, options: .noFileProtection)
    }
    
    // Convert Double to String and remove decimal value if 0
    static func discStatFormattedString(_ stat: Double) -> String {
        // Check of the decimal value is zero by comparing the absolute value to the rounded-down absolute value
        if abs(stat) == abs(stat).rounded(.down) {
            return String(format: "%.0f", stat)
        } else {
            return String(stat)
        }
    }
}

// MARK: Supporting types

// This enum provides a collection of disc types
enum DiscType: Equatable, Codable, CustomStringConvertible, CaseIterable {
    case putter, midrange, fairway, distance
    
    var description: String {
        switch self {
        case .putter:
            return "Putter"
        case .midrange:
            return "Midrange"
        case .fairway:
            return "Fairway"
        case .distance:
            return "Distance"
        }
    }
    
    // Return the index of a given option in the allCases array
    func getIndex() -> Self.AllCases.Index {
        return Self.allCases.firstIndex(of: self)!
    }
}

// This enum provides a collection of disc conditions
enum Condition: Equatable, Codable, CustomStringConvertible, CaseIterable {
    case great, good, fair, poor
    
    var description: String {
        switch self {
        case .great:
            return "Great"
        case .good:
            return "Good"
        case .fair:
            return "Fair"
        case .poor:
            return "Poor"
        }
    }
    
    // Return the index of a given option in the allCases array
    func getIndex() -> Self.AllCases.Index {
        return Self.allCases.firstIndex(of: self)!
    }
}

// This property wrapper and its extension contain the manual encoding implementation for UIColor, which keeps the Disc struct free from Codable clutter (CodingKeys enum, etc.)
@propertyWrapper
struct CodableColor {
    var wrappedValue: UIColor
}

// MARK: Extensions

// Codable conformance is placed in an extension to keep the UIColor class functionality intact (able to select fixed colors, i.e. .green)
extension CodableColor: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        guard let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid color"
            )
        }
        wrappedValue = color
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let data = try NSKeyedArchiver.archivedData(withRootObject: wrappedValue, requiringSecureCoding: true)
        try container.encode(data)
    }
}
