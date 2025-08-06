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
        private func timeUntilBuild(_ productionState: StateRobot) -> Int {
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
