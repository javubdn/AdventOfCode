class PlutoMaze {
    
    func calculateSteps(recursiveLevels: Bool) -> Int {
        while !movements.isEmpty {
            neighbors.forEach { neighbor in
                visited.insert(PositionLevel(point: neighbor, level: level))
                movements.append((neighbor, level, movement.2 + 1))
            }
        }
        return 0
    }
    
}
