//
//  Year2019InteractorImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 10/5/22.
//

import Foundation

class Year2019InteractorImpl: NSObject {
}

extension Year2019InteractorImpl: YearInteractor {
    
    @objc
    func day1question1() -> String {
        let input = readCSV("InputYear2019Day1").components(separatedBy: .newlines).map { Int($0)! }
        let result = input.map { $0/3 - 2 }.reduce(0, +)
        return String(result)
    }
    
    @objc
    func day1question2() -> String {
        let input = readCSV("InputYear2019Day1").components(separatedBy: .newlines).map { Int($0)! }
        let result = input.map { calculateFuel($0) }.reduce(0, +)
        return String(result)
    }
    
    func calculateFuel(_ mass: Int) -> Int {
        let fuel = mass/3 - 2
        if fuel <= 0 { return 0 }
        return fuel + calculateFuel(fuel)
    }
    
    @objc
    func day2question1() -> String {
        let input = "1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,10,19,1,6,19,23,1,10,23,27,2,27,13,31,1,31,6,35,2,6,35,39,1,39,5,43,1,6,43,47,2,6,47,51,1,51,5,55,2,55,9,59,1,6,59,63,1,9,63,67,1,67,10,71,2,9,71,75,1,6,75,79,1,5,79,83,2,83,10,87,1,87,5,91,1,91,9,95,1,6,95,99,2,99,10,103,1,103,5,107,2,107,6,111,1,111,5,115,1,9,115,119,2,119,10,123,1,6,123,127,2,13,127,131,1,131,6,135,1,135,10,139,1,13,139,143,1,143,13,147,1,5,147,151,1,151,2,155,1,155,5,0,99,2,0,14,0"
        var instructions = input.components(separatedBy: ",").map { Int($0)! }
        instructions[1] = 12
        instructions[2] = 2
        let result = executeIntCode(instructions)
        return String(result)
    }
    
    @objc
    func day2question2() -> String {
        let input = "1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,10,19,1,6,19,23,1,10,23,27,2,27,13,31,1,31,6,35,2,6,35,39,1,39,5,43,1,6,43,47,2,6,47,51,1,51,5,55,2,55,9,59,1,6,59,63,1,9,63,67,1,67,10,71,2,9,71,75,1,6,75,79,1,5,79,83,2,83,10,87,1,87,5,91,1,91,9,95,1,6,95,99,2,99,10,103,1,103,5,107,2,107,6,111,1,111,5,115,1,9,115,119,2,119,10,123,1,6,123,127,2,13,127,131,1,131,6,135,1,135,10,139,1,13,139,143,1,143,13,147,1,5,147,151,1,151,2,155,1,155,5,0,99,2,0,14,0"
        for noun in 0...99 {
            for verb in 0...99 {
                var instructions = input.components(separatedBy: ",").map { Int($0)! }
                instructions[1] = noun
                instructions[2] = verb
                let result = executeIntCode(instructions)
                if result == 19690720 {
                    return String(100 * noun + verb)
                }
            }
        }
        return ""
    }
    
    private func executeIntCode(_ instructions: [Int]) -> Int {
        var instructions = instructions
        for index in stride(from: 0, through: instructions.count, by: 4) {
            switch instructions[index] {
            case 1: instructions[instructions[index+3]] = instructions[instructions[index+1]] + instructions[instructions[index+2]]
            case 2: instructions[instructions[index+3]] = instructions[instructions[index+1]] * instructions[instructions[index+2]]
            case 99: return instructions[0]
            default: break
            }
        }
        return instructions[0]
    }
    
    @objc
    func day3question1() -> String {
        let input = readCSV("InputYear2019Day3").components(separatedBy: .newlines).map { $0.components(separatedBy: ",") }
        
        let segmentsFirstWire = getSegmentsWire(from: input[0])
        let segmentsSecondWire = getSegmentsWire(from: input[1])
        
        var pointsIntersect: [(Int, Int)] = []
        for segmentsFirstWireH in segmentsFirstWire[0] {
            let pointsH = Utils.intersectsSegment(segmentsFirstWireH, in: segmentsSecondWire[1], horizontal: true)
            pointsIntersect.append(contentsOf: pointsH)
        }
        for segmentsFirstWireV in segmentsFirstWire[1] {
            let pointsV = Utils.intersectsSegment(segmentsFirstWireV, in: segmentsSecondWire[0], horizontal: false)
            pointsIntersect.append(contentsOf: pointsV)
        }
        let result = pointsIntersect.filter { $0 != (0, 0) }.map { Utils.manhattanDistance($0, (0, 0)) }.min()!
        return String(result)
    }
    
    private func getSegmentsWire(from items: [String]) -> [[((Int, Int), (Int, Int))]] {
        var horizontalSegments: [((Int, Int), (Int, Int))] = []
        var verticalSegments: [((Int, Int), (Int, Int))] = []
        var lastPoint = (0, 0)
        for item in items {
            var nextPoint = lastPoint
            switch item[0] {
            case "U":
                nextPoint.1 -= Int(item[1..<item.count])!
                verticalSegments.append((nextPoint, lastPoint))
            case "D":
                nextPoint.1 += Int(item[1..<item.count])!
                verticalSegments.append((lastPoint, nextPoint))
            case "L":
                nextPoint.0 -= Int(item[1..<item.count])!
                horizontalSegments.append((nextPoint, lastPoint))
            case "R":
                nextPoint.0 += Int(item[1..<item.count])!
                horizontalSegments.append((lastPoint, nextPoint))
            default: break
            }
            lastPoint = nextPoint
        }
        return [horizontalSegments, verticalSegments]
    }
    
}
