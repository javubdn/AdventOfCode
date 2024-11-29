//
//  GameStatus.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 20/1/22.
//

import Foundation

class GameStatus {
    var playerHealth: Int
    var playerDefense: Int
    var playerMana: Int
    var bossHealth: Int
    var bossDamage: Int
    var shieldTimer: Int
    var poisonTimer: Int
    var rechargeTimer: Int
    var spentMana: Int
    
    init (playerHealth: Int, playerDefense: Int, playerMana: Int, bossHealth: Int, bossDamage: Int, shieldTimer: Int, poisonTimer: Int, rechargeTimer: Int, spentMana: Int) {
        self.playerHealth = playerHealth
        self.playerDefense = playerDefense
        self.playerMana = playerMana
        self.bossHealth = bossHealth
        self.bossDamage = bossDamage
        self.shieldTimer = shieldTimer
        self.poisonTimer = poisonTimer
        self.rechargeTimer = rechargeTimer
        self.spentMana = spentMana
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
            let copy = GameStatus(playerHealth: playerHealth, playerDefense: playerDefense, playerMana: playerMana, bossHealth: bossHealth, bossDamage: bossDamage, shieldTimer: shieldTimer, poisonTimer: poisonTimer, rechargeTimer: rechargeTimer, spentMana: spentMana)
            return copy
        }
}
