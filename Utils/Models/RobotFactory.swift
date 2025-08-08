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
        }
        func scheduleBuild(_ state: StateRobot) -> StateRobot? {
            let timeRequired = timeUntilBuild(state)
            guard timeRequired != Int.max else {
                return nil
            }
            return StateRobot(state.time + timeRequired,
                              state.geodeRobots + geodeRobotsBuilt
            )
        }
    }
}
