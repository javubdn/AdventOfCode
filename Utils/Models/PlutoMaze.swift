class PlutoMaze {
    
    func calculateSteps(recursiveLevels: Bool) -> Int {
        while !movements.isEmpty {
            if let portal = portals.first(where: { $0.point == position }) {
                if (portal.intern || level > 0 || !recursiveLevels),
                    let newPosition = portal.teleport(portals) {
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
