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
        var inRangePositions: [((Int, Int), Int, (Int, Int))] = []
        enemies.forEach { enemy in
            let x = enemy.position.x
            let y = enemy.position.y
            for (newX, newY) in [(x, y-1), (x-1, y), (x+1, y), (x, y+1)] {
                if scenario[newY][newX] == "." {
                    let movementLengthNew = movementLength(self.position, (x: newX, y: newY), scenario)
                    inRangePositions.append(((newX, newY), movementLengthNew.0, movementLengthNew.1))
                }
            }
        }
        inRangePositions = inRangePositions.sorted { position1, position2 in
            position1.1 < position2.1 || (position1.1 == position2.1 && Utils.firstReadingOrder(position1.0, position2.0))
        }
        if let nextPosition = inRangePositions.first, nextPosition.1 != Int.max {
            scenario[self.position.y][self.position.x] = "."
            self.position = nextPosition.2
            scenario[self.position.y][self.position.x] = self.type == .elf ? "E" : "G"
        }
        
        (_, scenario, characters) = attackClosestEnemy(enemies, characters, scenario)
        
        return (scenario, characters, isGameOver(characters))
    }
    
    private func isReachable(_ position: (x: Int, y: Int), _ scenario: [[String]]) -> Bool {
        movementLength(self.position, position, scenario).0 != Int.max
    }
    
    private func movementLength(_ positionI: (x: Int, y: Int), _ positionF: (x: Int, y: Int), _ scenario: [[String]]) -> (Int, (Int, Int)) {
        var movements: [(Int, Int, Int, (Int, Int))] = []
        var visited = [[Bool]](repeating: [Bool](repeating: false, count: scenario[0].count), count: scenario.count)
        visited[positionI.y][positionI.x] = true
        for (nextX, nextY) in [(positionI.x, positionI.y-1), (positionI.x-1, positionI.y), (positionI.x+1, positionI.y), (positionI.x, positionI.y+1)] {
            if scenario[nextY][nextX] == "." {
                movements.append((nextX, nextY, 1, (nextX, nextY)))
                visited[nextY][nextX] = true
            }
        }
        
        while !movements.isEmpty {
            let movement = movements.removeFirst()
            let x = movement.0
            let y = movement.1
            if x == positionF.x && y == positionF.y { return (movement.2, movement.3) }
            for (nextX, nextY) in [(x-1, y), (x, y-1), (x+1, y), (x, y+1)] {
                if scenario[nextY][nextX] == "." && !visited[nextY][nextX] {
                    movements.append((nextX, nextY, movement.2+1, movement.3))
                    visited[nextY][nextX] = true
                }
            }
        }
        return (Int.max, (0, 0))
    }
    
    private func attackClosestEnemy(_ enemies: [CombatCharacter], _ characters: [CombatCharacter], _ scenario: [[String]]) -> (Bool, [[String]], [CombatCharacter]) {
        var characters = characters
        var scenario = scenario
        
        var closerEnemies: [CombatCharacter] = []
        for close in [(-1, 0), (0, -1), (0, 1), (1, 0)] {
            let newP = (position.x + close.1, position.y + close.0)
            if let enemy = enemies.first(where: { $0.position == newP }) { closerEnemies.append(enemy) }
        }
        if !closerEnemies.isEmpty {
            closerEnemies = closerEnemies.sorted { $0.health < $1.health || ($0.health == $1.health && Utils.firstReadingOrder($0.position, $1.position)) }
            attack(closerEnemies.first!)
            if closerEnemies.first!.health <= 0 {
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
