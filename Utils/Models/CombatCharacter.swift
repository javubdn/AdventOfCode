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
    
    let type: CombatCharacterType
    var position: (x: Int, y: Int)
    private(set) var health = 200
    private let damage = 3
    
    init(type: CombatCharacterType, position: (x: Int, y: Int)) {
        self.type = type
        self.position = position
    }
    
    func receiveDamage(_ damage: Int) {
        health -= damage
    }
    
    func attack(_ character: CombatCharacter) {
        character.receiveDamage(damage)
    }
    
}
