//
//  SandMap.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 19/1/23.
//

private struct ActionQueue: Hashable {
    let x: Int
    let y: Int
}

class SandMap {
    
    fileprivate var rock: Set<Position> = []
    fileprivate var sand: Set<Position> = []
    private var minX: Int
    private var minY: Int
    private var maxX: Int
    private var maxY: Int
    private var queue: Set<ActionQueue> = []
    private var isFloor = false
    
    init(_ lines: [String], _ newFloor: Bool? = false) {
        if let newFloor = newFloor { isFloor = newFloor }
        for line in lines {
            var points = line.components(separatedBy: " -> ").map { $0.components(separatedBy: ",").map { Int($0)! } }
            var previousPoint = points.removeFirst()
            for point in points {
                if point[0] == previousPoint[0] {
                    for i in min(point[1], previousPoint[1])...max(point[1], previousPoint[1]) {
                        rock.insert(Position(x: point[0], y: i))
                    }
                } else {
                    for i in min(point[0], previousPoint[0])...max(point[0], previousPoint[0]) {
                        rock.insert(Position(x: i, y: point[1]))
                    }
                }
                previousPoint = point
            }
        }
        
        minX = rock.min { $0.x < $1.x }!.x
        minY = rock.min { $0.y < $1.y }!.y
        maxX = rock.max { $0.x < $1.x }!.x
        maxY = rock.max { $0.y < $1.y }!.y
        
        if isFloor {
            var pointsFloor = [[0, maxY + 2], [maxX*2, maxY + 2]]
            var previousPoint = pointsFloor.removeFirst()
            for point in pointsFloor {
                if point[0] == previousPoint[0] {
                    for i in min(point[1], previousPoint[1])...max(point[1], previousPoint[1]) {
                        rock.insert(Position(x: point[0], y: i))
                    }
                } else {
                    for i in min(point[0], previousPoint[0])...max(point[0], previousPoint[0]) {
                        rock.insert(Position(x: i, y: point[1]))
                    }
                }
                previousPoint = point
            }
            minX = rock.min { $0.x < $1.x }!.x
            minY = rock.min { $0.y < $1.y }!.y
            maxX = rock.max { $0.x < $1.x }!.x
            maxY = rock.max { $0.y < $1.y }!.y
        }
        
    }
    
}
