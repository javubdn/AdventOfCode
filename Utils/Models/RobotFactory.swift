//
//  RobotFactory.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 6/4/23.
//
import Foundation
class RobotFactory {
    class BluePrint {
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
