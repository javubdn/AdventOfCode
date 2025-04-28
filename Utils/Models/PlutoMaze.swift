class PlutoMaze {
    convenience init(from input: [String]) {
        input.enumerated().forEach { y, row in
            row.enumerated().forEach { x, c in
                let place = PointPlutoMaze(x: x, y: y)
                if c == "." { openSpaces.insert(place) }
                if "ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(c) {
                    let neighbor = place.neighbors().enumerated().first { point in
                        guard point.element.y >= 0 && point.element.y < input.count else {
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
                        let intern = PlutoMaze.isInsideHole(place, hole: hole)
                        portals.insert(portal)
                    }
                }
            }
        }
        self.init(openSpaces: openSpaces, portals: portals)
    }
    
    private static func getHole(_ input: [String]) -> ((Int, Int), Int, Int) {
        var input = input
        input = input.map { $0.replacingOccurrences(of: ".", with: "#") }
        let coordinates = Utils.cartesianProduct(lhs: Array(1...input.count-2), rhs: Array(1...input[2].count-2))
        let firstCorner = coordinates.first { coord in
            guard coord.0 > 0 && coord.1 > 0 && coord.1 < input[coord.0].count - 1 else { return false }
            return input[coord.0][coord.1] == " " && input[coord.0][coord.1-1] == "#" && input[coord.0-1][coord.1] == "#"
        }!
        let secondCorner = coordinates.first { coord in
            guard coord.0 > 0 && coord.1 > 0 && coord.1 < input[coord.0].count - 1 else { return false }
            return input[coord.0][coord.1] == " " && input[coord.0][coord.1+1] == "#" && input[coord.0-1][coord.1] == "#"
        }!
        let thirdCorner = coordinates.first { coord in
            guard coord.0 > 0 && coord.1 > 0 && coord.1 < input[coord.0].count - 1 else { return false }
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
