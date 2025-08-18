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
        func scheduleBuild(_ state: StateRobot) -> StateRobot? {
            guard timeRequired != Int.max else {
                return nil
            }
            return StateRobot(state.time + timeRequired,
            )
        }
    }
}
