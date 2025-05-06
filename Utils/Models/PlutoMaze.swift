class PlutoMaze {
    private static func getHole(_ input: [String]) -> ((Int, Int), Int, Int) {
        let thirdCorner = coordinates.first { coord in
            return input[coord.0][coord.1] == " " && input[coord.0][coord.1-1] == "#" && input[coord.0+1][coord.1] == "#"
        }!
        
        let width = secondCorner.1 - firstCorner.1 + 1
        let height = thirdCorner.0 - firstCorner.0 + 1
        return ((firstCorner.1, firstCorner.0), width, height)
    }
    
    private static func isInsideHole(_ point: PointPlutoMaze, hole: ((Int, Int), Int, Int)) -> Bool {
        point.x >= hole.0.0 && point.x < hole.0.0 + hole.1 && point.y >= hole.0.1 && point.y < hole.0.1 + hole.2
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
