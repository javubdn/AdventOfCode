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
    
    func possiblePositions(_ diagram: DiagramSituation, _ amphipods: [Amphipod]) -> [(Int, Int, Int)] {
        guard status != .final else { return [] }
        var positions: [(Int, Int, Int)] = []
        var positionsToReview = [(position.0, position.1, 0)]
        var visitedPositions: [(Int, Int)] = []
        while !positionsToReview.isEmpty {
            let currentPosition = positionsToReview.removeFirst()
            for difference in [(-1, 0), (1, 0), (0, -1), (0, 1)] {
                let nextPosition = (currentPosition.0+difference.0, currentPosition.1+difference.1)
                if diagram.distribution[nextPosition.0][nextPosition.1] == "."
                    && !diagram.isThereAmphipod(nextPosition, amphipods)
                    && !visitedPositions.contains(where: { $0.0 == nextPosition.0 && $0.1 == nextPosition.1}) {
                    positions.append((nextPosition.0, nextPosition.1, currentPosition.2+1))
                    positionsToReview.append((nextPosition.0, nextPosition.1, currentPosition.2+1))
                }
            }
            visitedPositions.append((currentPosition.0, currentPosition.1))
        }
        positions = positions.filter { item in
            !diagram.forbiddenPositions(type).contains { item.0 == $0 && item.1 == $1}
        }
        
        let correctPosition = diagram.amphipodTarget(self, amphipods)
        let possiblePositions = positions.filter { correctPosition.0.0 == $0.0 && correctPosition.0.1 == $0.1 }
        if status == .middle {
            positions = possiblePositions
        } else {
        }
        return positions
    }
    
}

class AmphipodsSituation {
    var amphipods: [Amphipod]
    
    init(amphipods: [Amphipod] ) {
        self.amphipods = amphipods
    }
    
}

extension AmphipodsSituation: Hashable {
    
    func hash(into hasher: inout Hasher) { }
    
    static func == (lhs: AmphipodsSituation, rhs: AmphipodsSituation) -> Bool {
        var equals = true
        for item in lhs.amphipods {
            equals = equals && rhs.amphipods.contains { rhsAmphipod in
                rhsAmphipod.position.0 == item.position.0 && rhsAmphipod.position.1 == item.position.1 && rhsAmphipod.type == item.type
            }
        }
        return equals
    }
    
}

class DiagramSituation {
    
    let distribution: [[String]]
    let targets: [AmphipodType: [(Int, Int)]]
    let amphipods: [Amphipod]
    var cost = 0
    
    var amphipodsSituations: [AmphipodsSituation: Int] = [:]
    
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
            
//        let targets: [AmphipodType: [(Int, Int)]] = [.amber, .bronze, .copper, .desert]
//            .enumerated()
//            .map { [$0.element: sortedPositions[positionKeys[$0.offset]]!] }
//            .reduce(into: [AmphipodType: [(Int, Int)]]()) { partialResult, point in
//                partialResult[point.keys.first!] = point.values.first!
//            }
        let targets: [AmphipodType: [(Int, Int)]] = [.amber: [(2, 3), (3, 3)],
                                                     .bronze: [(2, 5), (3, 5)],
                                                     .copper: [(2, 7), (3, 7)],
                                                     .desert: [(2, 9), (3, 9)]]
        self.init(distribution: distribution, targets: targets, amphipods: amphipods)
    }
    
    func calculateMovements() -> Int {
        var allSituations: [AmphipodsSituation: Int] = [:]
        var situations = [(AmphipodsSituation(amphipods: amphipods), 0)]
        while !situations.isEmpty {
            let situation = situations.removeFirst()
            let currentAmphipods = situation.0.amphipods
            let wrongAmphipods = incorrectAmphipods(currentAmphipods)
            if wrongAmphipods.count == 0 {
                return situation.1
            }
            for wrongAmphipod in wrongAmphipods {
                let movements = wrongAmphipod.possiblePositions(self, currentAmphipods)
                for movement in movements {
                    var newAmphipods = currentAmphipods.filter { $0.position.0 != wrongAmphipod.position.0 || $0.position.1 != wrongAmphipod.position.1 }
                    let newAmphipod = Amphipod(type: wrongAmphipod.type, position: (movement.0, movement.1))
                    newAmphipods.append(newAmphipod)
                    let amphipodsSituation = AmphipodsSituation(amphipods: newAmphipods)
                    let newCost = situation.1 + movement.2*newAmphipod.cost

                    if let value = allSituations[amphipodsSituation] {
                        if value <= newCost {
                            continue
                        } else {
                            allSituations[amphipodsSituation] = newCost
                            situations = situations.filter { $0.0 != amphipodsSituation }
                        }
                    } else {
                        allSituations[amphipodsSituation] = newCost
                    }
                    
                    if let index = situations.firstIndex(where: { $0.1 > newCost }) {
                        situations.insert((amphipodsSituation, newCost), at: index)
                    } else {
                        situations.append((amphipodsSituation, newCost))
                    }

                }
            }
        }

        return 444
    }
    
    func incorrectAmphipods(_ amphipods: [Amphipod]) -> [Amphipod] {
        amphipods.filter { !isCorrectAmphipod($0, amphipods) }
    }
    
    func isCorrectAmphipod(_ amphipod: Amphipod, _ amphipods: [Amphipod]) -> Bool {
        let position = amphipod.position
        let positions = targets[amphipod.type]!
        return positions.contains { $0.0 == position.0 && $0.1 == position.1 } && !isBlocking(amphipod, amphipods)
    }
    
    func isBlocking(_ amphipod: Amphipod, _ amphipods: [Amphipod]) -> Bool {
        let positions = targets[amphipod.type]!
        let amphipodsFilter = amphipods.filter { positions.last!.0 == $0.position.0 && positions.last!.1 == $0.position.1 }
        return !(amphipodsFilter.count == 0 || amphipodsFilter.first!.type == amphipod.type)
    }
    
    func forbiddenPositions(_ type: AmphipodType ) -> [(Int, Int)] {
        var positions = [(1, 3), (1, 5), (1, 7), (1, 9)]
        switch type {
        case .amber: positions.append(contentsOf: [(2, 5), (3, 5), (2, 7), (3, 7), (2, 9), (3, 9)])
        case .bronze: positions.append(contentsOf: [(2, 3), (3, 3), (2, 7), (3, 7), (2, 9), (3, 9)])
        case .copper: positions.append(contentsOf: [(2, 3), (3, 3), (2, 5), (3, 5), (2, 9), (3, 9)])
        case .desert: positions.append(contentsOf: [(2, 3), (3, 3), (2, 5), (3, 5), (2, 7), (3, 7)])
        }
        return positions
    }
    
    func isThereAmphipod(_ position: (Int, Int), _ amphipods: [Amphipod]) -> Bool {
        !amphipods.filter { $0.position.0 == position.0 && $0.position.1 == position.1 }.isEmpty
    }
    
    func giveMovements(_ amphipod: Amphipod) -> [Amphipod] {
//        amphipod.position.
        []
    }
    
    func amphipodTarget(_ amphipod: Amphipod, _ amphipods: [Amphipod]) -> ((Int, Int), Bool) {
        let possibleSolutions = targets[amphipod.type]!
        let amphipodInLastPlace = amphipods.filter { amp in
            amp.position.0 == possibleSolutions.last!.0 && amp.position.1 == possibleSolutions.last!.1
        }
        } else {
        }
    }
    
}
