class PlutoMaze {
    }
    
    func calculateSteps(recursiveLevels: Bool) -> Int {
        let firstPoint = portals.first { $0.keyName == "AA" }!.point.neighbors().first { openSpaces.contains($0) }!
        let lastPoint = portals.first { $0.keyName == "ZZ" }!.point.neighbors().first { openSpaces.contains($0) }!
        var movements = [(firstPoint, 0, 0)]
        var visited = Set([PositionLevel(point: portals.first { $0.keyName == "AA" }!.point, level: 0),
                           PositionLevel(point: firstPoint, level: 0)])
        while !movements.isEmpty {
            let movement = movements.removeFirst()
            var position = movement.0
            var level = movement.1
            if position == lastPoint && level == 0 {
                return movement.2
            }
            if let portal = portals.first(where: { $0.point == position }) {
                if (portal.intern || level > 0 || !recursiveLevels),
                    let newPosition = portal.teleport(portals) {
                    position = newPosition
                    level += !recursiveLevels ? 0 : portal.intern ? 1 : -1
                    visited.insert(PositionLevel(point: position, level: level))
                    position = position.neighbors().first { openSpaces.contains($0) }!
                    visited.insert(PositionLevel(point: position, level: level))
                }
            }
            let neighbors = position.neighbors()
                .filter { (openSpaces.contains($0)
                           || portals.map { $0.point }.contains($0))
                    && !visited.contains(PositionLevel(point: $0, level: level))}
            neighbors.forEach { neighbor in
                visited.insert(PositionLevel(point: neighbor, level: level))
                movements.append((neighbor, level, movement.2 + 1))
            }
        }
        return 0
    }
    
}
