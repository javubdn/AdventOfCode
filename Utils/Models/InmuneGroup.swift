//
//  InmuneGroup.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 5/5/22.
//

import Foundation

enum AttackType: Int {
    case fire
    case cold
    case slashing
    case radiation
    case bludgeoning
}

class InmuneGroup {
    
    let id: Int
    var units: Int
    let hit: Int
    let attack: Int
    let attackType: AttackType
    let initiative: Int
    let inmunities: [AttackType]
    let weaknesses: [AttackType]
    let isInmuneSystem: Bool
    lazy var effectivePower: Int = {
        units * attack
    }()
    var nextTargetId: Int = -1
    
    init(id: Int, units: Int, hit: Int, attack: Int, attackType: AttackType, initiative: Int, inmunities: [AttackType], weaknesses: [AttackType], isInmuneSystem: Bool) {
        self.id = id
        self.units = units
        self.hit = hit
        self.attack = attack
        self.attackType = attackType
        self.initiative = initiative
        self.inmunities = inmunities
        self.weaknesses = weaknesses
        self.isInmuneSystem = isInmuneSystem
    }
    
    func attack(_ enemy: InmuneGroup) -> Int {
        let damage = enemy.inmunities.contains(attackType) ? 0 :
                     enemy.weaknesses.contains(attackType) ? (units * attack) * 2 : (units * attack)
        let unitsLost = damage / enemy.hit
        enemy.units -= unitsLost
        return unitsLost
    }
    
    func potentialDamage(_ enemy: InmuneGroup) -> Int {
        if inmunities.contains(enemy.attackType) { return 0 }
        if weaknesses.contains(enemy.attackType) { return enemy.units * enemy.attack * 2 }
        return enemy.units * enemy.attack
    }
    
}
