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
        var instructions = readCSV("InputYear2019Day2").components(separatedBy: ",").map { Int($0)! }
        instructions[1] = 12
        instructions[2] = 2
        let result = executeIntCode(instructions)
        return String(result)
    }
    
    @objc
    func day2question2() -> String {
        let input = readCSV("InputYear2019Day2")
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
    
    @objc
    func day3question2() -> String {
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
        
        let allSegmentsFirstWire = getAllSegmentsWire(from: input[0])
        let allSegmentsSecondWire = getAllSegmentsWire(from: input[1])
        
        let result = pointsIntersect.filter { $0 != (0, 0) }.map { point -> Int in
            if let distance1 = distanceToPoint(point, segmentList: allSegmentsFirstWire),
                let distance2 = distanceToPoint(point, segmentList: allSegmentsSecondWire) {
                return distance1 + distance2
            }
            return Int.max
        }.min()!
        
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
    
    private func getAllSegmentsWire(from items: [String]) -> [((Int, Int), (Int, Int))] {
        var segments: [((Int, Int), (Int, Int))] = []
        var lastPoint = (0, 0)
        for item in items {
            var nextPoint = lastPoint
            switch item[0] {
            case "U":
                nextPoint.1 -= Int(item[1..<item.count])!
            case "D":
                nextPoint.1 += Int(item[1..<item.count])!
            case "L":
                nextPoint.0 -= Int(item[1..<item.count])!
            case "R":
                nextPoint.0 += Int(item[1..<item.count])!
            default: break
            }
            segments.append((lastPoint, nextPoint))
            lastPoint = nextPoint
        }
        return segments
    }
    
    private func distanceToPoint(_ point: (Int, Int), segmentList: [((Int, Int), (Int, Int))]) -> Int? {
        var distance = 0
        for segment in segmentList {
            if point.0 == segment.0.0 && point.0 == segment.1.0
                && (point.1 >= segment.0.1 && point.1 <= segment.1.1
                || point.1 <= segment.0.1 && point.1 >= segment.1.1) {
                return distance + abs(point.1 - segment.0.1)
            }
            if point.1 == segment.0.1 && point.1 == segment.1.1
                && (point.0 >= segment.0.0 && point.0 <= segment.1.0
                || point.0 <= segment.0.0 && point.0 >= segment.1.0) {
                return distance + abs(point.0 - segment.0.0)
            }
            distance += Utils.manhattanDistance(segment.0, segment.1)
        }
        return nil
    }
    
    @objc
    func day4question1() -> String {
//        let input = Array(367479...893698)
//        let result = input.filter { passwordHasCriteria($0, improved: false) }.count
//        return String(result)
        "496"
    }
    
    @objc
    func day4question2() -> String {
//        let input = Array(367479...893698)
//        let result = input.filter { passwordHasCriteria($0, improved: true) }.count
//        return String(result)
        "305"
    }
    
    private func passwordHasCriteria(_ password: Int, improved: Bool) -> Bool {
        var twoEquals = false
        var secuence2 = false
        var secuence2G = false
        for index in 0...4 {
            let currentDigit = password/Int(truncating: NSDecimalNumber(decimal: pow(10, 5-index))) % 10
            let nextDigit = password/Int(truncating: NSDecimalNumber(decimal: pow(10, 5-index-1))) % 10
            if nextDigit < currentDigit { return false }
            let repeatDigit = nextDigit == currentDigit
            if (improved && (!repeatDigit && secuence2 && !secuence2G) || (repeatDigit && !secuence2 && index == 4)) || (!improved && repeatDigit) {
                twoEquals = true
            }
            if improved && repeatDigit && secuence2 {
                secuence2G = true
            }
            if improved && repeatDigit && !secuence2 && index != 4 {
                secuence2 = true
            }
            if improved && !repeatDigit {
                secuence2 = false
                secuence2G = false
            }
            
        }
        return twoEquals
    }
    
    @objc
    func day5question1() -> String {
        let input = readCSV("InputYear2019Day5").components(separatedBy: ",").map { Int($0)! }
        let (_, output) = Intcode.executeIntCode(input, input: [1])
        let result = output.last!
        return String(result)
    }
    
    @objc
    func day5question2() -> String {
        let input = readCSV("InputYear2019Day5").components(separatedBy: ",").map { Int($0)! }
        let (_, output) = Intcode.executeIntCode(input, input: [5])
        let result = output.last!
        return String(result)
    }
    
}
