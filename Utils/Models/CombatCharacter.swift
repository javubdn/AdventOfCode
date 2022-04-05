//
//  CombatCharacter.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 31/3/22.
//

import Foundation

enum CombatCharacterType {
    case elf
    case goblin
}

class CombatCharacter {
    let id: UUID
    let type: CombatCharacterType
    var position: (x: Int, y: Int)
    private(set) var health = 200
    private let damage = 3
    
    init(type: CombatCharacterType, position: (x: Int, y: Int)) {
        id = UUID()
        self.type = type
        self.position = position
    }
    
    func receiveDamage(_ damage: Int) {
        health -= damage
    }
    
    func attack(_ character: CombatCharacter) {
        character.receiveDamage(damage)
    }
    
    func move(_ scenario: [[String]], characters: [CombatCharacter]) -> ([[String]], [CombatCharacter], Bool) {
        guard !isGameOver(characters) else { return (scenario, characters, true) }
        var scenario = scenario
        var characters = characters
        let attacked: Bool
        let enemies = characters.filter { $0.type != type }
        (attacked, scenario, characters) = attackClosestEnemy(enemies, characters, scenario)
        if attacked {
            return (scenario, characters, isGameOver(characters))
        }
        var inRangePositions: [(Int, Int)] = []
        enemies.forEach { enemy in
            let x = enemy.position.x
            let y = enemy.position.y
            if x > 0 && scenario[y][x-1] == "." { inRangePositions.append((x-1, y)) }
            if y > 0 && scenario[y-1][x] == "." { inRangePositions.append((x, y-1)) }
            if x < scenario[y].count-1 && scenario[y][x+1] == "." { inRangePositions.append((x+1, y)) }
            if y < scenario.count-1 && scenario[y+1][x] == "." { inRangePositions.append((x, y+1)) }
        }
        inRangePositions = inRangePositions.sorted { position1, position2 in
            let movementLength1 = movementLength(self.position, position1, scenario)
            let movementLength2 = movementLength(self.position, position2, scenario)
            return movementLength1 < movementLength2 || (movementLength1 == movementLength2 && Utils.firstReadingOrder(position1, position2))
        }
        if let nextPosition = inRangePositions.first, isReachable(nextPosition, scenario) {
            scenario = moveTo(nextPosition, in: scenario)
        }
        (_, scenario, characters) = attackClosestEnemy(enemies, characters, scenario)
        
        return (scenario, characters, isGameOver(characters))
    }
    
    private func isReachable(_ position: (x: Int, y: Int), _ scenario: [[String]]) -> Bool {
        movementLength(self.position, position, scenario) != Int.max
    }
    
    private func moveTo(_ position: (x: Int, y: Int), in scenario: [[String]]) -> [[String]] {
        let x = self.position.x
        let y = self.position.y
        var movements: [(Int, Int)] = []
        for index in [(x-1, y), (x, y-1), (x+1, y), (x, y+1)] {
            if index.0 >= 0 && index.0 < scenario[0].count
                && index.1 >= 0 && index.1 < scenario.count
                && scenario[index.1][index.0] == "." {
                movements.append((index.0, index.1))
            }
        }
        movements = movements.sorted { movement1, movement2 in
            let movementLength1 = movementLength(movement1, position, scenario)
            let movementLength2 = movementLength(movement2, position, scenario)
            return movementLength1 < movementLength2 || (movementLength1 == movementLength2 && Utils.firstReadingOrder(movement1, movement2))
        }
        var scenario = scenario
        scenario[self.position.y][self.position.x] = "."
        if let nextMovement = movements.first {
            self.position = nextMovement
            scenario[self.position.y][self.position.x] = self.type == .elf ? "E" : "G"
        }
        return scenario
    }
    
    private func movementLength(_ positionI: (x: Int, y: Int), _ positionF: (x: Int, y: Int), _ scenario: [[String]]) -> Int {
        var movements: [(Int, Int, Int)] = [(positionI.x, positionI.y, 0)]
        var visited = [[Bool]](repeating: [Bool](repeating: false, count: scenario[0].count), count: scenario.count)
        while !movements.isEmpty {
            let movement = movements.removeFirst()
            let x = movement.0
            let y = movement.1
            if x == positionF.x && y == positionF.y { return movement.2 }
            if x > 0 && scenario[y][x-1] == "." && !visited[y][x-1] { movements.append((x-1, y, movement.2+1)) }
            if y > 0 && scenario[y-1][x] == "." && !visited[y-1][x] { movements.append((x, y-1, movement.2+1)) }
            if x < scenario[y].count-1 && scenario[y][x+1] == "."  && !visited[y][x+1] { movements.append((x+1, y, movement.2+1)) }
            if y < scenario.count-1 && scenario[y+1][x] == "." && !visited[y+1][x] { movements.append((x, y+1, movement.2+1)) }
            for index in [(x-1, y), (x, y-1), (x+1, y), (x, y+1)] {
                if index.0 >= 0 && index.0 < scenario[0].count
                    && index.1 >= 0 && index.1 < scenario.count
                    && scenario[index.1][index.0] == "." && !visited[index.1][index.0] {
                    movements.append((index.0, index.1, movement.2+1))
                    visited[index.1][index.0] = true
                }
            }
        }
        return Int.max
    }
    
    private func attackClosestEnemy(_ enemies: [CombatCharacter], _ characters: [CombatCharacter], _ scenario: [[String]]) -> (Bool, [[String]], [CombatCharacter]) {
        var characters = characters
        var scenario = scenario
        var closerEnemies = enemies.filter { Utils.manhattanDistance(position, $0.position) == 1 }
        if closerEnemies.count > 0 {
            closerEnemies = closerEnemies.sorted { $0.health < $1.health || ($0.health == $1.health && Utils.firstReadingOrder($0.position, $1.position)) }
            attack(closerEnemies[0])
            if closerEnemies[0].health <= 0 {
                characters.removeAll { $0.id == closerEnemies[0].id }
                scenario[closerEnemies[0].position.y][closerEnemies[0].position.x] = "."
            }
            return (true, scenario, characters)
        }
        return (false, scenario, characters)
    }
    
    private func isGameOver(_ characters: [CombatCharacter]) -> Bool {
        let enemies = characters.filter { $0.type != type }
        return enemies.isEmpty
    }
    
}
