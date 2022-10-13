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
    
    
}
