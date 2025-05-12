class PlutoMaze {
    
    func calculateSteps(recursiveLevels: Bool) -> Int {
        while !movements.isEmpty {
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
