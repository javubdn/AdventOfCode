//
//  DiagramSituation.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 11/10/22.
//

import Foundation

enum AmphipodType: String {
    case amber = "A"
    case bronze = "B"
    case copper = "C"
    case desert = "D"
}

enum AmphipodStatus {
    case origin
    case middle
    case final
}

class Amphipod {
    
    let type: AmphipodType
    var position: (Int, Int)
    var status: AmphipodStatus = .origin
    
    init(type: AmphipodType, position: (Int, Int)) {
        self.type = type
        self.position = position
    }
    
    func isBlocking() -> Bool {
        position.0 == 1 && (position.1 == 3 || position.1 == 5 || position.1 == 7 || position.1 == 9)
    }
    
    func canMove() -> Bool {
        true
    }
    
    func possiblePositions(_ diagram: DiagramSituation) -> [(Int, Int)] {
        var positions: [(Int, Int)] = []
        var positionsToReview = [position]
        var visitedPositions: [(Int, Int)] = [] // = diagram.forbiddenPositions()
        while !positionsToReview.isEmpty {
            let currentPosition = positionsToReview.removeFirst()
            for difference in [(-1, 0), (1, 0), (0, -1), (0, 1)] {
                let nextPosition = (currentPosition.0+difference.0, currentPosition.1+difference.1)
                if diagram.distribution[nextPosition.0][nextPosition.1] == "."
                    && !diagram.isThereAmphipod(nextPosition)
                    && !visitedPositions.contains(where: { $0.0 == nextPosition.0 && $0.1 == nextPosition.1}) {
                    positions.append(nextPosition)
                    positionsToReview.append(nextPosition)
                }
            }
            visitedPositions.append(currentPosition)
        }
        positions = positions.filter { item in
            !diagram.forbiddenPositions().contains { item.0 == $0 && item.1 == $1}
        }
        return positions
    }
    
}

class DiagramSituation {
    
    let distribution: [[String]]
    let targets: [AmphipodType: [(Int, Int)]]
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
