//
//  DiagramSituation.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 11/10/22.
//

import Foundation

class DiagramSituation {
    
    let distribution: [[String]]
    let targets: [(Int, Int)]
    let amphipods: [Amphipod]
    
    init(distribution: [[String]], targets: [(Int, Int)], amphipods: [Amphipod]) {
        self.distribution = distribution
        self.targets = targets
        self.amphipods = amphipods
    }
    
    convenience init(_ input: String) {
        var distribution = input.components(separatedBy: .newlines).map { $0.map { String($0) } }
        let amphipods = distribution.enumerated().flatMap { line -> [Amphipod] in
            line.element.enumerated().compactMap { element -> Amphipod? in
                guard element.element != "#" && element.element != "." && element.element != " " else { return nil }
                return Amphipod(type: AmphipodType(rawValue: element.element)!, position: (line.offset, element.offset))
            }
        }
        var targets = amphipods.map { $0.position }
        targets.forEach { distribution[$0.0][$0.1] = "." }
        var t: [AmphipodType: [(Int, Int)]]
        let wat = Dictionary(grouping: targets.sorted { $0.1 < $1.1 }, by: { $0.1 })
        self.init(distribution: distribution, targets: targets, amphipods: amphipods)
    }
    
    
}
