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
    
    class StateRobot {
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
        
        func canOutproduceBest(_ maxGeodes: Int, _ timeBudget: Int) -> Bool {
            let timeLeft = timeBudget - time
            let potentialProduction = (0...timeLeft).map { $0 + geodeRobots }.reduce(0, +)
            return geodes + potentialProduction > maxGeodes
        }
        
        func calculateNextStates(_ blueprint: BluePrint, _ timeBudget: Int) -> [StateRobot] {
            guard time < timeBudget else { return [] }
            var nextStates: [StateRobot] = []
            if let oreState = blueprint.oreRobot.scheduleBuild(self) {
                nextStates.append(oreState)
            }
            if let clayState = blueprint.clayRobot.scheduleBuild(self) {
                nextStates.append(clayState)
            }
            if let obsidianState = blueprint.obsidianRobot.scheduleBuild(self) {
                nextStates.append(obsidianState)
            }
            if let geodeState = blueprint.geodeRobot.scheduleBuild(self) {
                nextStates.append(geodeState)
            }
            return nextStates.filter { $0.time <= timeBudget }
        }
    }

    class BluePrint {
        let id: Int
        let oreRobot: RobotBlueprint
        let clayRobot: RobotBlueprint
        let obsidianRobot: RobotBlueprint
        let geodeRobot: RobotBlueprint
        
        init(_ id: Int,
             _ oreRobot: RobotBlueprint,
             _ clayRobot: RobotBlueprint,
             _ obsidianRobot: RobotBlueprint,
             _ geodeRobot: RobotBlueprint) {
            self.id = id
            self.oreRobot = oreRobot
            self.clayRobot = clayRobot
            self.obsidianRobot = obsidianRobot
            self.geodeRobot = geodeRobot
        }
        
        func maxOre() -> Int {
            max(oreRobot.oreCost, clayRobot.oreCost, obsidianRobot.oreCost, geodeRobot.oreCost)
        }

        func maxClay() -> Int {
            max(oreRobot.clayCost, clayRobot.clayCost, obsidianRobot.clayCost, geodeRobot.clayCost)
        }
        
        func maxObsidian() -> Int {
            max(oreRobot.obsidianCost, clayRobot.obsidianCost, obsidianRobot.obsidianCost, geodeRobot.obsidianCost)
        }

    }
    
    class RobotBlueprint {
        let oreRobotsBuilt: Int
        let clayRobotsBuilt: Int
        let obsidianRobotsBuilt: Int
        let geodeRobotsBuilt: Int
        let oreCost: Int
        let clayCost: Int
        let obsidianCost: Int
        
        init(_ oreRobotsBuilt: Int,
             _ clayRobotsBuilt: Int,
             _ obsidianRobotsBuilt: Int,
             _ geodeRobotsBuilt: Int,
             _ oreCost: Int,
             _ clayCost: Int = 0,
             _ obsidianCost: Int = 0) {
            self.oreRobotsBuilt = oreRobotsBuilt
            self.clayRobotsBuilt = clayRobotsBuilt
            self.obsidianRobotsBuilt = obsidianRobotsBuilt
            self.geodeRobotsBuilt = geodeRobotsBuilt
            self.oreCost = oreCost
            self.clayCost = clayCost
            self.obsidianCost = obsidianCost
        }
        
        private func timeUntilBuild(_ productionState: StateRobot) -> Int {
            let neededOre = oreCost - productionState.ore
            let neededClay = clayCost - productionState.clay
            let neededObsidian = obsidianCost - productionState.obsidian
            if oreRobotsBuilt == 1 || clayRobotsBuilt == 1 {
                return (neededOre <= 0 ? 0 : Int(ceil(Double(neededOre)/Double(productionState.oreRobots)))) + 1
            } else if obsidianRobotsBuilt == 1 {
                guard productionState.clayRobots > 0 else { return Int.max }
                return max(neededOre <= 0 ? 0 : Int(ceil(Double(neededOre)/Double(productionState.oreRobots))),
                           neededClay <= 0 ? 0 : Int(ceil(Double(neededClay) / Double(productionState.clayRobots)))) + 1
            } else {
                guard productionState.obsidianRobots > 0 else { return Int.max }
                return max(neededOre <= 0 ? 0 : Int(ceil(Double(neededOre)/Double(productionState.oreRobots))),
                           neededObsidian <= 0 ? 0 : Int(ceil(Double(neededObsidian) / Double(productionState.obsidianRobots)))
                       ) + 1
            }            
        }
        
        func scheduleBuild(_ state: StateRobot) -> StateRobot? {
            let timeRequired = timeUntilBuild(state)
            guard timeRequired != Int.max else {
                return nil
            }
            return StateRobot(state.time + timeRequired,
                              (state.ore - oreCost) + (timeRequired * state.oreRobots),
                              state.oreRobots + oreRobotsBuilt,
                              (state.clay - clayCost) + (timeRequired * state.clayRobots),
                              state.clayRobots + clayRobotsBuilt,
                              (state.obsidian - obsidianCost) + (timeRequired * state.obsidianRobots),
                              state.obsidianRobots + obsidianRobotsBuilt,
                              state.geodes + (timeRequired * state.geodeRobots),
                              state.geodeRobots + geodeRobotsBuilt
            )
        }
    }
}
    /*
    class RobotMap {
        private func getNewStateH(_ state: StateRobot,
                                 _ combination: (Bool, Bool, Bool, Bool)) -> StateRobot {
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
*/
