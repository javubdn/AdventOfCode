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
        
        func bestObsidian(_ cycles: Int) -> Int {
            let stateMain = StateRobot(a: 1, b: 0, c: 0, d: 0, e: 0, f: 0, g: 0, h: 0, i: cycles)
            let result = recurs(stateMain)
            return result
        }
        
            var oreBots = state.0
            var clayBots = state.1
            var obsBots = state.2
            var geoBots = state.3
            var ores = state.4
            var clays = state.5
            var obsids = state.6
            var geos = state.7
            let time = state.8
            var newOres = false
            var newClays = false
            var newObs = false
            var newGeos = false
            
//            if geodeCost.0 <= ores && geodeCost.1 <= obsids {
//                newGeos = true
//                ores -= geodeCost.0
//                obsids -= geodeCost.1
//            }
//            if obsidianCost.0 <= ores && obsidianCost.1 <= clays {
//                newObs = true
//                ores -= obsidianCost.0
//                clays -= obsidianCost.1
//            }
//            if clayCost <= ores {
//                newClays = true
//                ores -= clayCost
//            }
//            if oreCost <= ores {
//                newOres = true
//                ores -= oreCost
//            }
//            ores += oreBots
//            clays += clayBots
//            obsids += obsBots
}
