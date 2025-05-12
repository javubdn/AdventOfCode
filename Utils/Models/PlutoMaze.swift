class PlutoMaze {
    
    func calculateSteps(recursiveLevels: Bool) -> Int {
        while !movements.isEmpty {
            neighbors.forEach { neighbor in
                movements.append((neighbor, level, movement.2 + 1))
            }
        }
        return 0
    }
    
}
