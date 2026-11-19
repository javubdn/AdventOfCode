//
//  Beam.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 18/11/2026.
//

class Beam: Hashable {
    struct Point: Hashable {
        var row: Int
        var col: Int
    }
    
    var position: Point
    var direction: Direction
    
    init(position: Point, direction: Direction) {
        self.position = position
        self.direction = direction
    }
    
    static func == (lhs: Beam, rhs: Beam) -> Bool {
        return lhs.position == rhs.position && lhs.direction == rhs.direction
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
        hasher.combine(direction)
    }
    
    func executeStep(in map: [[String]]) -> [Beam] {
        guard map.indices.contains(position.row),
              map[position.row].indices.contains(position.col) else {
            return []
        }
        let tile = map[position.row][position.col]
        switch tile {
        case ".":
            move()
            return [self]
        case "/":
            direction = (direction == .north || direction == .south)
                ? direction.turnRight()
                : direction.turnLeft()
            move()
            return [self]
        case "\\":
            direction = (direction == .north || direction == .south)
                ? direction.turnLeft()
                : direction.turnRight()
            move()
            return [self]
        case "|":
            if direction == .north || direction == .south {
                move()
                return [self]
            }
            let southBeam = Beam(position: Point(row: position.row + 1, col: position.col), direction: .south)
            direction = .north
            move()
            return [self, southBeam]
        case "-":
            if direction == .east || direction == .west {
                move()
                return [self]
            }
            let eastBeam = Beam(position: Point(row: position.row, col: position.col + 1), direction: .east)
            direction = .west
            move()
            return [self, eastBeam]
        default: return []
        }

    }
    
    private func move() {
        switch direction {
        case .north:
            position.row -= 1
        case .south:
            position.row += 1
        case .east:
            position.col += 1
        case .west:
            position.col -= 1
        }
    }
}
