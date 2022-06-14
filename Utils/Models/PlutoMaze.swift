//
//  PlutoMaze.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 10/6/22.
//

import Foundation

class PlutoMaze {
    
    struct PointPlutoMaze: Hashable {
        let x: Int
        let y: Int
        
        func neighbors() -> [PointPlutoMaze] {
            [PointPlutoMaze(x: x, y: y-1),
             PointPlutoMaze(x: x, y: y+1),
             PointPlutoMaze(x: x-1, y: y),
             PointPlutoMaze(x: x+1, y: y)]
        }
    }
    
    struct PointPortal: Hashable {
        let point: PointPlutoMaze
        let keyName: String
        func teleport(_ portals: Set<PointPortal>) -> PointPlutoMaze {
            portals.first { $0.keyName == keyName && $0.point != point }!.point
        }
    }
    
    private let portals: Set<PointPortal>
    private let openSpaces: Set<PointPlutoMaze>
    
    init(openSpaces: Set<PointPlutoMaze>, portals: Set<PointPortal>) {
        self.openSpaces = openSpaces
        self.portals = portals
    }
    
    convenience init(from input: [String]) {
        var openSpaces: Set<PointPlutoMaze> = Set()
        var portals: Set<PointPortal> = Set()
        input.enumerated().forEach { y, row in
            row.enumerated().forEach { x, c in
                let place = PointPlutoMaze(x: x, y: y)
                if c == "." { openSpaces.insert(place) }
                if "ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(c) {
                    let neighbor = place.neighbors().enumerated().first { point in
                        guard point.element.y >= 0 && point.element.y < input.count else {
                            return false
                        }
                        guard point.element.x >= 0 && point.element.x < input[point.element.y].count else {
                            return false
                        }
                        return "ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(input[point.element.y][point.element.x])
                    }
                    if let neighbor = neighbor,
                       neighbor.offset == 1 || neighbor.offset == 3 {
                        let portalX = neighbor.offset == 3 && (x == 0 || input[y][x-1] != ".") ? x + 1 : x
                        let portalY = neighbor.offset == 1 && (y == 0 || input[y-1][x] != ".") ? y + 1 : y
                        let keyName = String(c) + String(input[neighbor.element.y][neighbor.element.x])
                        let portal = PointPortal(point: PointPlutoMaze(x: portalX, y: portalY), keyName: keyName)
                        portals.insert(portal)
                    }
                }
            }
        }
        self.init(openSpaces: openSpaces, portals: portals)
    }
    
    func calculateSteps() -> Int {
        let firstPoint = portals.first { $0.keyName == "AA" }!.point.neighbors().first { openSpaces.contains($0) }!
        let lastPoint = portals.first { $0.keyName == "ZZ" }!.point.neighbors().first { openSpaces.contains($0) }!
        var movements = [(firstPoint, 0)]
        var visited = [portals.first { $0.keyName == "AA" }!.point, firstPoint]
        while !movements.isEmpty {
            let movement = movements.removeFirst()
            var position = movement.0
            if position == lastPoint {
                return movement.1
            }
            if let portal = portals.first(where: { $0.point == position }) {
                position = portal.teleport(portals)
                visited.append(position)
                position = position.neighbors().first { openSpaces.contains($0) }!
                visited.append(position)
            }
            let neighbors = position.neighbors().filter { (openSpaces.contains($0) || portals.map { $0.point }.contains($0)) && !visited.contains($0) }
            neighbors.forEach { neighbor in
                visited.append(neighbor)
                movements.append((neighbor, movement.1 + 1))
            }
        }
        return 0
    }
    
}
