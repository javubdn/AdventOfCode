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
        
        private func getStates(_ state: (Int, Int, Int, Int, Int, Int, Int, Int, Int)) -> [(Int, Int, Int, Int, Int, Int, Int, Int, Int)] {
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
//            geos += geoBots
//            oreBots += newOres ? 1 : 0
//            clayBots += newClays ? 1 : 0
//            obsBots += newObs ? 1 : 0
//            geoBots += newGeos ? 1 : 0
//
//            let statusBasic = (oreBots, clayBots, obsBots, geoBots, ores+oreBots, clays+clayBots, obsids+obsBots, geos+geoBots, time - 1)
//
            var states: [(Int, Int, Int, Int, Int, Int, Int, Int, Int)] = []
            for first in [true, false] {
                for second in [true, false] {
                    for third in [true, false] {
                        for fourth in [true, false] {
                            if isPossibleState((ores, clays, obsids, geos), (first, second, third, fourth)) {
                                states.append(getNewState(state, (first, second, third, fourth)))
                            }
                        }
                    }
                }
            }
            
            return states
        }
        
        private func isPossibleState(_ state: (Int, Int, Int, Int), _ combination: (Bool, Bool, Bool, Bool)) -> Bool {
            var state = state
            if combination.0 {
                let (canOres, oresAfterOre) = canGetOre(state.0)
                guard canOres else { return false }
                state.0 = oresAfterOre
            }
            if combination.1 {
                let (canClays, oresAfterClay) = canGetClay(state.0)
                guard canClays else { return false }
                state.0 = oresAfterClay
            }
            if combination.2 {
                let (canObs, (oresAfterObs, claysAfterObs)) = canGetObs(state.0, state.1)
                guard canObs else { return false }
                state.0 = oresAfterObs
                state.1 = claysAfterObs
            }
            if combination.3 {
                let (canGeods, _) = canGetGeods(state.0, state.2)
                guard canGeods else { return false}
            }
            
            return true
        }
        
        private func getNewState(_ state: (Int, Int, Int, Int, Int, Int, Int, Int, Int),
                                 _ combination: (Bool, Bool, Bool, Bool)) -> (Int, Int, Int, Int, Int, Int, Int, Int, Int) {
            var newState = state
            if combination.0 {
                newState.4 -= oreCost
                newState.0 += 1
            }
            if combination.1 {
                newState.4 -= clayCost
                newState.1 += 1
            }
            if combination.2 {
                newState.4 -= obsidianCost.0
                newState.5 -= obsidianCost.1
                newState.2 += 1
             }
            if combination.3 {
                newState.4 -= geodeCost.0
                newState.6 -= geodeCost.1
                newState.3 += 1
            }
            newState.4 += state.0
            newState.5 += state.1
            newState.6 += state.2
            newState.7 += state.3
            newState.8 -= 1
            return newState
        }
        
        private func canGetOre(_ ores: Int) -> (Bool, Int) {
            (oreCost <= ores, ores - oreCost)
        }
        
        private func canGetClay(_ ores: Int) -> (Bool, Int) {
            (clayCost <= ores, ores - clayCost)
        }
        
        private func canGetObs(_ ores: Int, _ clays: Int) -> (Bool, (Int, Int)) {
            (obsidianCost.0 <= ores && obsidianCost.1 <= clays, (ores - obsidianCost.0, clays - obsidianCost.1))
        }
        
        private func canGetGeods(_ ores: Int, _ obsids: Int) -> (Bool, (Int, Int)) {
            (geodeCost.0 <= ores && geodeCost.1 <= obsids, (ores - geodeCost.0, obsids - geodeCost.1))
        }
        
        struct StateRobot: Hashable {
            let a: Int
            let b: Int
            let c: Int
            let d: Int
            let e: Int
            let f: Int
            let g: Int
            let h: Int
            let i: Int
            
            func canOutproduceBest(_ maxGeodes: Int, _ timeBudget: Int) -> Bool {
                let timeLeft = timeBudget - i
                let potentialProduction = d*timeLeft + ((timeLeft * (timeLeft+1))/2)
                return h + potentialProduction > maxGeodes
            }
            
            func calculateNextStates(_ robotMap: RobotMap, _ timeBudget: Int) -> [StateRobot] {
                guard i < timeBudget else { return [] }
                var nextStates: [StateRobot] = []
                if (robotMap.maxOre() > a && e > 0) {
                    nextStates.append(<#T##newElement: RobotFactory.RobotMap.StateRobot##RobotFactory.RobotMap.StateRobot#>) += blueprint.oreRobot.scheduleBuild(this)
                }
                                if (blueprint.maxClay > clayRobots && ore > 0) {
                                    nextStates += blueprint.clayRobot.scheduleBuild(this)
                                }
                                if (blueprint.maxObsidian > obsidianRobots && ore > 0 && clay > 0) {
                                    nextStates += blueprint.obsidianRobot.scheduleBuild(this)
                                }
                                if (ore > 0 && obsidian > 0) {
                                    nextStates += blueprint.geodeRobot.scheduleBuild(this)
                                }
                            }
                            return nextStates.filter { it.time <= timeBudget }
                return []
            }
        }
        
        var statustus: [StateRobot: Int] = [:]
        
        private func getStatesH(_ state: StateRobot) -> [StateRobot] {
            var oreBots = state.a
            var clayBots = state.b
            var obsBots = state.c
            var geoBots = state.d
            var ores = state.e
            var clays = state.f
            var obsids = state.g
            var geos = state.h
            let time = state.i
            var newOres = false
            var newClays = false
            var newObs = false
            var newGeos = false
            
            var states: [StateRobot] = []
            for first in [true, false] {
                for second in [true, false] {
                    for third in [true, false] {
                        for fourth in [true, false] {
                            if isPossibleState((ores, clays, obsids, geos), (first, second, third, fourth)) {
                                states.append(getNewStateH(state, (first, second, third, fourth)))
                            }
                        }
                    }
                }
            }
            
            return states
        }
        
            var (a, b, c, d, e, f, g, h, i) = (state.a, state.b, state.c, state.d, state.e, state.f, state.g, state.h, state.i)
            if combination.0 {
                e -= oreCost
                a += 1
            }
            if combination.1 {
                e -= clayCost
                b += 1
            }
                e -= obsidianCost.0
}
