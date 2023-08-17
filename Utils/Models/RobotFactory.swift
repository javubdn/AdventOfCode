//
//  RobotFactory.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 6/4/23.
//

import Foundation

class RobotFactory {
    
    var blueprints: [BluePrint] = []
    
    func addMap(_ input: String) {
        let regex = try! NSRegularExpression(pattern: #"Blueprint ([0-9]+): Each ore robot costs ([0-9]+) ore. Each clay robot costs ([0-9]+) ore. Each obsidian robot costs ([0-9]+) ore and ([0-9]+) clay. Each geode robot costs ([0-9]+) ore and ([0-9]+) obsidian."#)
        let matches = regex.matches(in: input, options: [], range: NSRange(input.startIndex..., in: input))
        let match = matches.first!
        let id = Int(String(input[Range(match.range(at: 1), in: input)!]))!
        let oreCost = Int(String(input[Range(match.range(at: 2), in: input)!]))!
        let clayOreCost = Int(String(input[Range(match.range(at: 3), in: input)!]))!
        let obsidianOreCost = Int(String(input[Range(match.range(at: 4), in: input)!]))!
        let obsidianClayCost = Int(String(input[Range(match.range(at: 5), in: input)!]))!
        let geodeOreCost = Int(String(input[Range(match.range(at: 6), in: input)!]))!
        let geodeObsidianCost = Int(String(input[Range(match.range(at: 7), in: input)!]))!
        let oreRobot = RobotBlueprint(1, 0, 0, 0, oreCost)
        let clayRobot = RobotBlueprint(0, 1, 0, 0, clayOreCost)
        let obsidianRobot = RobotBlueprint(0, 0, 1, 0, obsidianOreCost, obsidianClayCost)
        let geodeRobot = RobotBlueprint(0, 0, 0, 1, geodeOreCost, 0, geodeObsidianCost)
        blueprints.append(BluePrint(id, oreRobot, clayRobot, obsidianRobot, geodeRobot))
    }
    
    func executeCalculation() -> Int {
        blueprints.map { calculateGeodesFound($0, 24) * $0.id }.reduce(0, +)
    }
    
    func calculateGeodesFound(_ blueprint: BluePrint ,_ timeBudget: Int) -> Int {
        var maxGeodes = 0
        var states = Heap(elements: [StateRobot()]) { $0.geodes > $1.geodes }
        while !states.isEmpty {
            let state = states.dequeue()!
            if state.canOutproduceBest(maxGeodes, timeBudget) {
                state.calculateNextStates(blueprint, timeBudget).forEach { states.enqueue($0) }
            }
            maxGeodes = max(maxGeodes, state.geodes)
        }
        return maxGeodes
    }
    
        let time: Int
        let ore: Int
        let oreRobots: Int
        let clay: Int
        let clayRobots: Int
        let obsidian: Int
        let obsidianRobots: Int
        let geodes: Int
        let geodeRobots: Int
        
        init(_ time: Int = 1,
             _ ore: Int = 1,
             _ oreRobots: Int = 1,
             _ clay: Int = 0,
             _ clayRobots: Int = 0,
             _ obsidian: Int = 0,
             _ obsidianRobots: Int = 0,
             _ geodes: Int = 0,
             _ geodeRobots: Int = 0) {
            self.time = time
            self.ore = ore
            self.oreRobots = oreRobots
            self.clay = clay
            self.clayRobots = clayRobots
            self.obsidian = obsidian
            self.obsidianRobots = obsidianRobots
            self.geodes = geodes
            self.geodeRobots = geodeRobots
        }
        
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
        
        private func getNewStateH(_ state: StateRobot,
                                 _ combination: (Bool, Bool, Bool, Bool)) -> StateRobot {
            var (a, b, c, d, e, f, g, h, i) = (state.a, state.b, state.c, state.d, state.e, state.f, state.g, state.h, state.i)
            if combination.0 {
                e -= oreCost
                a += 1
            }
            if combination.1 {
                e -= clayCost
                b += 1
            }
            if combination.2 {
                e -= obsidianCost.0
                f -= obsidianCost.1
                c += 1
             }
            if combination.3 {
                e -= geodeCost.0
                g -= geodeCost.1
                d += 1
            }
            e += state.a
            f += state.b
            g += state.c
            h += state.d
            i -= 1
            return StateRobot(a: a, b: b, c: c, d: d, e: e, f: f, g: g, h: h, i: i)
        }
        
        private func recurs(_ state: StateRobot) -> Int {
            if let st = statustus[state] {
                return st
            }
            guard state.i > 0 else { return state.h }
            let states = getStatesH(state)
            let minim = states.map { recurs($0) }.max()!
            statustus[state] = minim
            return minim
        }
        
    }
    
    var robotMap: [RobotMap] = []
    
    func addMap(_ input: String) {
        let regex = try! NSRegularExpression(pattern: #"Blueprint ([0-9]+): Each ore robot costs ([0-9]+) ore. Each clay robot costs ([0-9]+) ore. Each obsidian robot costs ([0-9]+) ore and ([0-9]+) clay. Each geode robot costs ([0-9]+) ore and ([0-9]+) obsidian."#)
        let matches = regex.matches(in: input, options: [], range: NSRange(input.startIndex..., in: input))
        let match = matches.first!
        let id = Int(String(input[Range(match.range(at: 1), in: input)!]))!
        let oreCost = Int(String(input[Range(match.range(at: 2), in: input)!]))!
        let clayOreCost = Int(String(input[Range(match.range(at: 3), in: input)!]))!
        let obsidianOreCost = Int(String(input[Range(match.range(at: 4), in: input)!]))!
        let obsidianClayCost = Int(String(input[Range(match.range(at: 5), in: input)!]))!
        let geodeOreCost = Int(String(input[Range(match.range(at: 6), in: input)!]))!
        let geodeObsidianCost = Int(String(input[Range(match.range(at: 7), in: input)!]))!
        robotMap.append(RobotMap(id, oreCost, clayOreCost, (obsidianOreCost, obsidianClayCost), (geodeOreCost, geodeObsidianCost)))
    }
    
    func executeCalculation() -> Int {
        robotMap.map { $0.bestObsidian(24) * $0.id }.reduce(0, +)
    }
    
}
