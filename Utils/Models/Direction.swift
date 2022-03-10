//
//  Direction.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 3/3/22.
//

enum TurnDirection {
    case left
    case right
    case reverse
    case same
}

enum Direction {
    case north
    case south
    case west
    case east
    
    func turnLeft() -> Direction {
        switch self {
        case .north: return .west
        case .south: return .east
        case .west: return .south
        case .east: return .north
        }
    }
    
    func turnRight() -> Direction {
        switch self {
        case .north: return .east
        case .south: return .west
        case .west: return .north
        case .east: return .south
        }
    }
    
    func turn(_ turn: TurnDirection) -> Direction {
        switch self {
        case .north: return turn == .left ? .west : turn == .right ? .east : turn == .reverse ? .south : .north
        case .south: return turn == .left ? .east : turn == .right ? .west : turn == .reverse ? .north : .south
        case .west: return turn == .left ? .south : turn == .right ? .north : turn == .reverse ? .east : .west
        case .east: return turn == .left ? .north : turn == .right ? .south : turn == .reverse ? .west : .east
        }
    }
    
}
