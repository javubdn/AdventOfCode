//
//  RobotFactory.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 6/4/23.
//

import Foundation

class RobotFactory {
    class RobotMap {
        let id: Int
        let oreCost: Int
        let clayCost: Int
        let obsidianCost: (Int, Int)
        let geodeCost: (Int, Int)
        
        func maxOre() -> Int { max(oreCost, clayCost, obsidianCost.0, geodeCost.0) }
        func maxClay() -> Int { obsidianCost.1 }
        func maxObsidian() -> Int { geodeCost.1 }
        
        init(_ id: Int, _ oreCost: Int, _ clayCost: Int, _ obsidianCost: (Int, Int), _ geodeCost: (Int, Int)) {
            self.id = id
            self.oreCost = oreCost
            self.clayCost = clayCost
            self.obsidianCost = obsidianCost
            self.geodeCost = geodeCost
        }
        
        func calculateGeodesFound(_ timeBudget: Int) -> Int {
            var maxGeodes = 0
            var states = [StateRobot(a: 1, b: 0, c: 0, d: 0, e: 1, f: 0, g: 0, h: 0, i: 1)]
            while !states.isEmpty {
                let state = states.removeFirst()
                if state.canOutproduceBest(maxGeodes, timeBudget) {
                    states.append(contentsOf: state.calculateNextStates(self, timeBudget))
                }
                maxGeodes = max(maxGeodes, state.h)
            }
            return maxGeodes
        }
        
//            }
//            return bestResult
}
