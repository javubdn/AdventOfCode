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
    func cost() -> Int {
        switch self {
        case .amber: return 1
        case .bronze: return 10
        case .copper: return 100
        case .desert: return 1000
        }
    }
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
    var cost: Int = 0
    
    init(type: AmphipodType, position: (Int, Int)) {
        self.type = type
        self.cost = type.cost()
        self.position = position
    }
    
    func isBlocking() -> Bool {
        position.0 == 1 && (position.1 == 3 || position.1 == 5 || position.1 == 7 || position.1 == 9)
    }
    
    func canMove() -> Bool {
        true
    }
    
    func possiblePositions(_ diagram: DiagramSituation) -> [(Int, Int, Int)] {
        guard status != .final else { return [] }
        var positions: [(Int, Int, Int)] = []
        var positionsToReview = [(position.0, position.1, 0)]
        var visitedPositions: [(Int, Int)] = []
        while !positionsToReview.isEmpty {
            let currentPosition = positionsToReview.removeFirst()
            for difference in [(-1, 0), (1, 0), (0, -1), (0, 1)] {
                let nextPosition = (currentPosition.0+difference.0, currentPosition.1+difference.1)
                if diagram.distribution[nextPosition.0][nextPosition.1] == "."
                    && !diagram.isThereAmphipod(nextPosition)
                    && !visitedPositions.contains(where: { $0.0 == nextPosition.0 && $0.1 == nextPosition.1}) {
                    positions.append((nextPosition.0, nextPosition.1, currentPosition.2+1))
                    positionsToReview.append((nextPosition.0, nextPosition.1, currentPosition.2+1))
                }
            }
            visitedPositions.append((currentPosition.0, currentPosition.1))
        }
        positions = positions.filter { item in
            !diagram.forbiddenPositions().contains { item.0 == $0 && item.1 == $1}
        }
        if status == .middle {
            let correctPositions = diagram.targets[type]!
            positions = positions.filter { position in
                correctPositions.contains(where: { correctPosition in
                    correctPosition.0 == position.0 && correctPosition.1 == position.1
                })
            }
        }
        return positions
    }
    
}

class DiagramSituation {
    
    let distribution: [[String]]
    let targets: [AmphipodType: [(Int, Int)]]
    let amphipods: [Amphipod]
    var cost = 0
    
    init(distribution: [[String]], targets: [AmphipodType: [(Int, Int)]], amphipods: [Amphipod]) {
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
        let positions = amphipods.map { $0.position }
        positions.forEach { distribution[$0.0][$0.1] = "." }
        let sortedPositions = Dictionary(grouping: positions.sorted { $0.1 < $1.1 }, by: { $0.1 })
        let positionKeys = sortedPositions.keys.sorted { $0 < $1 }
            
        let targets: [AmphipodType: [(Int, Int)]] = [.amber, .bronze, .copper, .desert]
            .enumerated()
            .map { [$0.element: sortedPositions[positionKeys[$0.offset]]!] }
            .reduce(into: [AmphipodType: [(Int, Int)]]()) { partialResult, point in
                partialResult[point.keys.first!] = point.values.first!
            }
        self.init(distribution: distribution, targets: targets, amphipods: amphipods)
    }
    
    func calculateMovements() -> Int {
        let wrongAmphipods = incorrectAmphipods()
        guard wrongAmphipods.count > 0 else { return cost }
        for wrongAmphipod in wrongAmphipods {
            let movements = wrongAmphipod.possiblePositions(self)
        }
        return 444
    }
    
}
