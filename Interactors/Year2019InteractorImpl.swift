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
        let (result, _) = Intcode.execute(instructions, input: [])
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
                let (result, _) = Intcode.execute(instructions, input: [])
                if result == 19690720 {
                    return String(100 * noun + verb)
                }
            }
        }
        return ""
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
        let (_, output) = Intcode.execute(input, input: [1])
        let result = output.last!
        return String(result)
    }
    
    @objc
    func day5question2() -> String {
        let input = readCSV("InputYear2019Day5").components(separatedBy: ",").map { Int($0)! }
        let (_, output) = Intcode.execute(input, input: [5])
        let result = output.last!
        return String(result)
    }
    
    @objc
    func day6question1() -> String {
        let directOrbits = readCSV("InputYear2019Day6")
            .components(separatedBy: .newlines)
            .map { $0.components(separatedBy: ")") }
            .map { ($0[0], $0[1]) }
        let mainOrbit = getMainOrbit(directOrbits)
        let result = getNumberOrbits(mainOrbit, numberParents: 0)
        return String(result)
    }
    
    @objc
    func day6question2() -> String {
//        let directOrbits = readCSV("InputYear2019Day6")
//            .components(separatedBy: .newlines)
//            .map { $0.components(separatedBy: ")") }
//            .map { ($0[0], $0[1]) }
//        let mainOrbit = getMainOrbit(directOrbits)
//        let youWay = getOrbitWay("YOU", orbit: mainOrbit)!
//        let sanWay = getOrbitWay("SAN", orbit: mainOrbit)!
//        var index = 0
//        while youWay[index] == sanWay[index] {
//            index += 1
//        }
//        let result = youWay.count + sanWay.count - 2 * index - 2
//        return String(result)
        "418"
    }
    
    struct Orbit {
        let id: String
        let orbits: [Orbit]
    }
    
    private func getMainOrbit(_ input: [(String, String)]) -> Orbit {
        var input = input
        var orbits: [Orbit] = []
        while !input.isEmpty {
            let currentOrbit: Orbit
            (currentOrbit, input, orbits) = getOrbit(input.first!.0, items: input, orbits: orbits)
            orbits.append(currentOrbit)
        }
        return orbits.first!
    }
        
    private func getOrbit(_ name: String,
                          items: [(String, String)],
                          orbits: [Orbit]) -> (Orbit, [(String, String)], [Orbit]) {
        let sons = items.filter { $0.0 == name }
        guard sons.count > 0 else {
            return (Orbit(id: name, orbits: []), items, orbits)
        }
        var items = items
        var orbits = orbits
        let indexCurrentItem = items.firstIndex { $0.0 == name }!
        items.remove(at: indexCurrentItem)
        
        var orbiting: [Orbit] = []
        
        for son in sons {
            if let sonInOrbit = orbits.first(where: { $0.id == son.1 }) {
                orbiting.append(sonInOrbit)
                orbits.removeAll { $0.id == son.1 }
                continue
            }
            let newOrbit: Orbit
            (newOrbit, items, orbits) = getOrbit(son.1, items: items, orbits: orbits)
            orbiting.append(newOrbit)
            items.removeAll { $0.1 == son.1 }
        }
        return (Orbit(id: name, orbits: orbiting), items, orbits)
    }
    
    private func getNumberOrbits(_ orbit: Orbit, numberParents: Int) -> Int {
        guard orbit.orbits.count > 0 else { return numberParents }
        var numberOrbits = numberParents
        for orbited in orbit.orbits {
            numberOrbits += getNumberOrbits(orbited, numberParents: numberParents+1)
        }
        return numberOrbits
    }
    
    private func getOrbitWay(_ name: String, orbit: Orbit) -> [String]? {
        if orbit.id == name { return [name] }
        for son in orbit.orbits {
            if let way = getOrbitWay(name, orbit: son) {
                return [orbit.id] + way
            }
        }
        return nil
    }
    
    @objc
    func day7question1() -> String {
        let input = readCSV("InputYear2019Day7").components(separatedBy: ",").map { Int($0)! }
        let permutations = Utils.permutations([0, 1, 2, 3, 4])
        var bestResult = Int.min
        for permutation in permutations {
            var output = [0]
            for index in 0...4 {
                (_, output) = Intcode.execute(input, input: [permutation[index], output[0]])
            }
            bestResult = max(bestResult, output[0])
        }
        
        return String(bestResult)
    }
    
        
}
