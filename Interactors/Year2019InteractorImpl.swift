//
//  Year2019InteractorImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 10/5/22.
//

import Foundation
import CoreText
import CoreXLSX

class Year2019InteractorImpl: NSObject {
    var inventory: [String: Int] = [:]
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
        let intCode = Intcode(instructions: instructions)
        intCode.execute()
        let result = intCode.instructions[0]
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
                let intCode = Intcode(instructions: instructions)
                intCode.execute()
                let result = intCode.instructions[0]
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
        let intCode = Intcode(instructions: input)
        intCode.addInput([1])
        intCode.execute()
        let result = intCode.readOutput().last!
        return String(result)
    }
    
    @objc
    func day5question2() -> String {
        let input = readCSV("InputYear2019Day5").components(separatedBy: ",").map { Int($0)! }
        let intCode = Intcode(instructions: input)
        intCode.addInput([5])
        intCode.execute()
        let result = intCode.readOutput().last!
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
                let intcode = Intcode(instructions: input)
                intcode.addInput([permutation[index]] + output)
                intcode.execute()
                output = intcode.readOutput()
            }
            bestResult = max(bestResult, output[0])
        }
        return String(bestResult)
    }
    
    @objc
    func day7question2() -> String {
        let input = readCSV("InputYear2019Day7").components(separatedBy: ",").map { Int($0)! }
        let permutations = Utils.permutations(Array(5...9))
        var bestResult = Int.min
        for permutation in permutations {
            var intCodes: [Intcode] = []
            for index in 0...4 {
                let intCode = Intcode(instructions: input)
                intCode.addInput([permutation[index]])
                intCodes.append(intCode)
            }
            var output = [0]
            var maintainLoop = true
            while maintainLoop {
                for index in 0...4 {
                    let intcode = intCodes[index]
                    intcode.addInput(output)
                    intcode.execute()
                    output = intcode.readOutput()
                }
                let completed = intCodes.filter { $0.completed }.count
                if completed == 5 {
                    maintainLoop = false
                }
            }
            bestResult = max(bestResult, output.last!)
        }
        
        return String(bestResult)
    }
    
    @objc
    func day8question1() -> String {
        let input = readCSV("InputYear2019Day8").map { Int(String($0))! }
        var layers: [(Int, Int, Int)] = []
        for index in Array(stride(from: 0, to: input.count, by: 25*6)) {
            let num0 = input[index..<index+25*6].filter { $0 == 0 }.count
            let num1 = input[index..<index+25*6].filter { $0 == 1 }.count
            let num2 = input[index..<index+25*6].filter { $0 == 2 }.count
            layers.append((num0, num1, num2))
        }
        let bestLayer = layers.sorted { $0.0 < $1.0 }.first!
        let result = bestLayer.1 * bestLayer.2
        return String(result)
    }
    
    @objc
    func day8question2() -> String {
        let input = readCSV("InputYear2019Day8").map { Int(String($0))! }
        var layer: [[Int]] = [[Int]](repeating: [Int](repeating: -1, count: 25), count: 6)
        for row in 0..<6 {
            for col in 0..<25 {
                for index in Array(stride(from: 0, to: input.count, by: 25*6)) {
                    if input[index + row*25 + col] != 2 {
                        layer[row][col] = input[index + row*25 + col]
                        break
                    }
                }
            }
        }
        let text = layer.map { $0.map{ $0 == 0 ? "." : "*" }.joined() }
        text.forEach{ print($0) }
        return "HFYAK"
    }
    
    @objc
    func day9question1() -> String {
        let input = readCSV("InputYear2019Day9").components(separatedBy: ",").map { Int($0)! }
        let intcode = Intcode(instructions: input)
        intcode.addInput([1])
        intcode.execute()
        let result = intcode.readOutput().first!
        return String(result)
    }
    
    @objc
    func day9question2() -> String {
        let input = readCSV("InputYear2019Day9").components(separatedBy: ",").map { Int($0)! }
        let intcode = Intcode(instructions: input)
        intcode.addInput([2])
        intcode.execute()
        let result = intcode.readOutput()[0]
        return String(result)
    }
    
    @objc
    func day10question1() -> String {
        let input = readCSV("InputYear2019Day10").components(separatedBy: .newlines).map { Array($0).map { String($0) } }
        let coordenates = Utils.cartesianProduct(lhs: Array(0..<input.count), rhs: Array(0..<input[0].count)).filter { input[$0.0][$0.1] == "#" }
        let result = coordenates.map { visibleAsteroids(from: $0, in: coordenates) }.max()!
        return String(result)
    }
    
    @objc
    func day10question2() -> String {
        let input = readCSV("InputYear2019Day10").components(separatedBy: .newlines).map { Array($0).map { String($0) } }
        let coordenates = Utils.cartesianProduct(lhs: Array(0..<input.count), rhs: Array(0..<input[0].count)).filter { input[$0.0][$0.1] == "#" }
        let bestCoordenate = coordenates.sorted { visibleAsteroids(from: $0, in: coordenates) > visibleAsteroids(from: $1, in: coordenates) }.first!
        let sortedCoordenates = coordenates.filter { $0.0 != bestCoordenate.0 || $0.1 != bestCoordenate.1 }.sorted { bestAngleAsteroid(bestCoordenate, $0, $1) }
        var cycleCoordinates = sortedCoordenates.map { ($0, 0) }
        var index = 1
        while index < cycleCoordinates.count {
            if distanceToAsteroid(bestCoordenate, cycleCoordinates[index].0).0 == distanceToAsteroid(bestCoordenate, cycleCoordinates[index-1].0).0 {
                cycleCoordinates[index].1 = cycleCoordinates[index-1].1 + 1
            }
            index += 1
        }
        let sortedCycleCoordinates = cycleCoordinates.enumerated().sorted { $0.element.1 < $1.element.1 || ($0.element.1 == $1.element.1 && $0.offset < $1.offset ) }
        let coordenate200 = sortedCycleCoordinates[199].element.0
        let result = coordenate200.1 * 100 + coordenate200.0
        return String(result)
    }
    
    struct Vector: Hashable {
        let x: Int
        let y: Int
    }
    
    private func visibleAsteroids(from coordenate: (Int, Int), in asteroids: [(Int, Int)]) -> Int {
        let vectors = asteroids.filter { $0.0 != coordenate.0 || $0.1 != coordenate.1 }.map { asteroid -> Vector in
            let diffY = asteroid.0 - coordenate.0
            let diffX = asteroid.1 - coordenate.1
            let commonDivisor = Utils.gcd(diffX, diffY)
            return Vector(x: commonDivisor == 0 ? diffX : diffX/commonDivisor, y: commonDivisor == 0 ? diffY : diffY/commonDivisor)
        }
        return Set(vectors).count
        
    }
    
    private func distanceToAsteroid(_ reference: (Int, Int), _ asteroid: (Int, Int)) -> ((Int, Int), Int) {
        let diffY = asteroid.0 - reference.0
        let diffX = asteroid.1 - reference.1
        let commonDivisor = Utils.gcd(diffX, diffY)
        return ((commonDivisor == 0 ? diffX : diffX/commonDivisor, commonDivisor == 0 ? diffY : diffY/commonDivisor), commonDivisor)
    }
    
    private func bestAngleAsteroid(_ bestCoordenate: (Int, Int), _ asteroid1: (Int, Int), _ asteroid2: (Int, Int)) -> Bool {
        let distance1 = distanceToAsteroid(bestCoordenate, asteroid1)
        let distance2 = distanceToAsteroid(bestCoordenate, asteroid2)
        let quadrants = ["01": 1, "21": 2, "20": 3, "22": 4, "02": 5, "12": 6, "10": 7, "11": 8]
        let q1 = quadrants[(distance1.0.0 == 0 ? "0" : distance1.0.0 < 0 ? "1" : "2") + (distance1.0.1 == 0 ? "0" : distance1.0.1 < 0 ? "1" : "2")]!
        let q2 = quadrants[(distance2.0.0 == 0 ? "0" : distance2.0.0 < 0 ? "1" : "2") + (distance2.0.1 == 0 ? "0" : distance2.0.1 < 0 ? "1" : "2")]!
        let angle1 = distance1.0.0 == 0 ? 0 : Double(distance1.0.1)/Double(distance1.0.0)
        let angle2 = distance2.0.0 == 0 ? 0 : Double(distance2.0.1)/Double(distance2.0.0)
        return q1 < q2 || ( q1 == q2 && ( angle1 < angle2 || (angle1 == angle2 && distance1.1 < distance2.1) ) )
    }
    
    @objc
    func day11question1() -> String {
        let (result, _) = paintPanel(mode: 0, panelSize: (58, 107), initialPosition: (96, 6))
        return String(result)
    }
    
    @objc
    func day11question2() -> String {
        let (_, result) = paintPanel(mode: 1, panelSize: (43, 6), initialPosition: (0, 0))
        return result
    }
    
    private func paintPanel(mode: Int, panelSize: (Int, Int), initialPosition: (Int, Int)) -> (Int, String) {
        let input = readCSV("InputYear2019Day11").components(separatedBy: ",").map { Int($0)! }
        let intcode = Intcode(instructions: input)
        var panel = [[Int]](repeating: [Int](repeating: 0, count: panelSize.0), count: panelSize.1)
        var position = initialPosition
        panel[position.0][position.1] = mode
        var changed = [[Bool]](repeating: [Bool](repeating: false, count: panelSize.0), count: panelSize.1)
        var orientation = Direction.north
        while !intcode.completed {
            intcode.addInput([panel[position.0][position.1]])
            intcode.execute()
            let output = intcode.readOutput()
            panel[position.0][position.1] = output[0]
            changed[position.0][position.1] = true
            orientation = orientation.turn(output[1] == 0 ? .left : .right)
            position.0 += orientation == .north ? -1 : orientation == .south ? 1 : 0
            position.1 += orientation == .west ? -1 : orientation == .east ? 1 : 0
        }
        
        let panelString = panel.map { $0.map { $0 == 0 ? "." : "#" }.joined() }
        panelString.forEach { print($0) }
        let result = changed.map { $0.filter { $0 }.count }.reduce(0, +)
        return (result, "HAFULAPE")
        
    }
    
    @objc
    func day12question1() -> String {
        let input = readCSV("InputYear2019Day12")
        let moons = getMoons(input)
        for _ in 1...1000 {
            for moon in moons {
                moon.updateSpeed(moons)
            }
            for moon in moons {
                moon.move()
            }
        }
        let result = moons.map { $0.energy() }.reduce(0, +)
        return String(result)
    }
    
    @objc
    func day12question2() -> String {
//        let input = readCSV("InputYear2019Day12")
//        let moons = getMoons(input)
//        let startingX = moons.map { $0.getX() }
//        let startingY = moons.map { $0.getY() }
//        let startingZ = moons.map { $0.getZ() }
//        var foundX: Int? = nil
//        var foundY: Int? = nil
//        var foundZ: Int? = nil
//        var numSteps = 0
//        while foundX == nil || foundY == nil || foundZ == nil {
//            for moon in moons {
//                moon.updateSpeed(moons)
//            }
//            for moon in moons {
//                moon.move()
//            }
//            numSteps += 1
//            foundX = foundX == nil && startingX == moons.map { $0.getX() } ? numSteps : foundX
//            foundY = foundY == nil && startingY == moons.map { $0.getY() } ? numSteps : foundY
//            foundZ = foundZ == nil && startingZ == moons.map { $0.getZ() } ? numSteps : foundZ
//        }
//        let result = Utils.lcm(foundX!, Utils.lcm(foundY!, foundZ!))
//        return String(result)
        "496734501382552"
    }
    
    private func getMoons(_ input: String) -> [Moon] {
        let items = input.components(separatedBy: .newlines).map { $0.dropFirst().dropLast() }
        var id = 1
        var moons: [Moon] = []
        for item in items {
            let positions = item.components(separatedBy: ", ")
            let x = Int(positions[0].components(separatedBy: "=")[1])!
            let y = Int(positions[1].components(separatedBy: "=")[1])!
            let z = Int(positions[2].components(separatedBy: "=")[1])!
            let moon = Moon(id, position: (x: x, y: y, z: z))
            moons.append(moon)
            id += 1
        }
        return moons
    }
    
    @objc
    func day13question1() -> String {
        let input = readCSV("InputYear2019Day13").components(separatedBy: ",").map { Int($0)! }
        let intCode = Intcode(instructions: input)
        intCode.execute()
        let output = intCode.readOutput() //intCode.output
        var result = 0
        for index in stride(from: 2, to: output.count, by: 3) {
            result += output[index] == 2 ? 1 : 0
        }
        return String(result)
    }
    
    @objc
    func day13question2() -> String {
        let input = readCSV("InputYear2019Day13").components(separatedBy: ",").map { Int($0)! }
        let intCode = Intcode(instructions: input)
        intCode.instructions[0] = 2
        var score = 0
        var paddleX = 0
        var ballX = 0
        while !intCode.completed {
            intCode.execute()
            let output = intCode.readOutput()
            for index in stride(from: 0, to: output.count, by: 3) {
                let x = output[index]
                let value = output[index+2]
                if x == -1 {
                    score = value
                }
                else if value == 3 {
                    paddleX = x
                }
                else if value == 4 {
                    ballX = x
                }
            }
            intCode.addInput([ballX < paddleX ? -1 : ballX > paddleX ? 1 : 0])
        }
        return String(score)
    }
    
    @objc
    func day14question1() -> String {
        let input = readCSV("InputYear2019Day14").components(separatedBy: .newlines)
        let cost: [String: (Int, [(Int, String)])] = getReactionCosts(input)
        let result = calculateCost(cost: cost)
        return String(result)
    }
    
    @objc
    func day14question2() -> String {
        let input = readCSV("InputYear2019Day14").components(separatedBy: .newlines)
        let cost: [String: (Int, [(Int, String)])] = getReactionCosts(input)
        let result = Utils.binarySearchBy((0, 1_000_000_000_000)) { value in
            inventory = [:]
            return 1_000_000_000_000 - calculateCost(amount: value, cost: cost)
        }
        return String(result)
    }
    
    struct Reaction {
        let ingredients: [(name: String, quantity: Int)]
        let result: (name: String, quantity: Int)
    }
    
    private func getReaction(_ input: String) -> Reaction {
        let elements = input.components(separatedBy: " => ")
        let ingredients = elements[0].components(separatedBy: ", ")
        var ingr: [(String, Int)] = []
        ingredients.forEach { ingredient in
            let values = ingredient.components(separatedBy: .whitespaces)
            ingr.append((values[1], Int(values[0])!))
        }
        let resultValues = elements[1].components(separatedBy: .whitespaces)
        let result = (resultValues[1], Int(resultValues[0])!)
        return Reaction(ingredients: ingr, result: result)
    }
    
    private func getReactionCosts(_ input: [String]) -> [String: (Int, [(Int, String)])] {
        let reactions = input.map { getReaction($0) }
        var costs: [String: (Int, [(Int, String)])] = [:]
        for reaction in reactions {
            var ingredients: [(Int, String)] = []
            for item in reaction.ingredients {
                ingredients.append((item.quantity, item.name))
            }
            costs[reaction.result.name] = (reaction.result.quantity, ingredients)
        }
        return costs
    }
    
    private func calculateCost(material: String = "FUEL",
                               amount: Int = 1,
                               cost: [String: (Int, [(Int, String)])]) -> Int {
        guard material != "ORE" else { return amount }
        let inventoryQuantity = inventory[material] ?? 0
        var needQuantity = 0
        if inventoryQuantity > 0 {
            inventory[material] = max(inventoryQuantity - amount, 0)
            needQuantity = amount - inventoryQuantity
        } else {
            needQuantity = amount
        }
        if needQuantity > 0 {
            let recipe = cost[material]!
            let iterations = Int(ceil(Double(needQuantity) / Double(recipe.0)))
            let actuallyProduced = recipe.0 * iterations
            if needQuantity < actuallyProduced {
                inventory[material] = (inventory[material] ?? 0) + actuallyProduced - needQuantity
            }
            return recipe.1.map { calculateCost(material: $0.1, amount: $0.0*iterations, cost: cost) }.reduce(0, +)
        }
        return 0
    }
    
    @objc
    func day15question1() -> String {
//        let input = readCSV("InputYear2019Day15").components(separatedBy: ",").map { Int($0)! }
//        let (result, _, _) = calculateLeak(input, fullMap: false)
//        return "\(result)"
        "366"
    }
    
    @objc
    func day15question2() -> String {
//        let input = readCSV("InputYear2019Day15").components(separatedBy: ",").map { Int($0)! }
//        var (_, positionRepair, visited) = calculateLeak(input, fullMap: true)
//        var positions = [(positionRepair, 0)]
//        var time = 0
//        while !positions.isEmpty {
//            let position = positions.removeFirst()
//            visited[position.0.1][position.0.0] = 3
//            for nextMovement in 1...4 {
//                let nextX = position.0.0 + (nextMovement == 3 ? -1 : nextMovement == 4 ? 1 : 0)
//                let nextY = position.0.1 + (nextMovement == 1 ? -1 : nextMovement == 2 ? 1 : 0)
//                if visited[nextY][nextX] == 1 {
//                    positions.append(((nextX, nextY), position.1 + 1))
//                }
//            }
//            time = max(time, position.1)
//        }
//        return "\(time)"
        "384"
    }
    
    private func calculateLeak(_ input: [Int], fullMap: Bool) -> (Int, (Int, Int), [[Int]]) {
        var movements: [([Int], (Int, Int))] = [([1], (21, 20)),([2], (21, 22)),([3], (20, 21)),([4], (22, 21))]
        var visited = [[Int]](repeating: [Int](repeating: -1, count: 41), count: 41)
        visited[21][21] = 1
        var positionRepair = (0, 0)
        while !movements.isEmpty {
            let movement = movements.removeFirst()
            let intcode = Intcode(instructions: input)
            intcode.addInput(movement.0)
            intcode.execute()
            let output = intcode.readOutput()
            let nextValue = output.last!
            if nextValue == 0 {
                visited[movement.1.1][movement.1.0] = 2
            } else if nextValue == 1 {
                visited[movement.1.1][movement.1.0] = 1
                for nextMovement in 1...4 {
                    let nextX = movement.1.0 + (nextMovement == 3 ? -1 : nextMovement == 4 ? 1 : 0)
                    let nextY = movement.1.1 + (nextMovement == 1 ? -1 : nextMovement == 2 ? 1 : 0)
                    if visited[nextY][nextX] == -1 {
                        movements.append((movement.0 + [nextMovement], (nextX, nextY)))
                    }
                }
            } else if nextValue == 2 {
                visited[movement.1.1][movement.1.0] = 0
                positionRepair = movement.1
                if !fullMap { return (movement.0.count, positionRepair, visited) }
            }
        }
        return (0, positionRepair, visited)
    }
    
    @objc
    func day16question1() -> String {
//        let input = readCSV("InputYear2019Day16").map { Int(String($0))! }
//        var result: [Int] = input
//        for _ in 1...100 {
//            result = fft(result)
//        }
//        return "\(result[0...7].map { String($0) }.joined())"
        "30369587"
    }
    
    @objc
    func day16question2() -> String {
//        let input = readCSV("InputYear2019Day16").map { Int(String($0))! }
//        let offset = Int(input[0...6].map { String($0) }.joined())!
//        var stretchedInput = Array(offset..<(10000*input.count)).map { input[$0 % input.count] }
//        for _ in 0..<100 {
//            var sum = 0
//            stretchedInput.enumerated().reversed().forEach { value in
//                sum = (sum + value.element) % 10
//                stretchedInput[value.offset] = sum
//            }
//        }
//        return "\(stretchedInput[0...7].map { String($0) }.joined())"
        "27683551"
    }
    
    private func fft(_ input: [Int]) -> [Int] {
        var result: [Int] = []
        for i in 0..<input.count {
            var sum = 0
            var mult = 1
            for index in stride(from: i, to: input.count, by: (i+1)*2) {
                for position in index...min(index+i, input.count-1) {
                    sum += input[position] * mult
                }
                mult *= -1
            }
            result.append(abs(sum)%10)
        }
        return result
    }
    
    @objc
    func day17question1() -> String {
        let input = readCSV("InputYear2019Day17").components(separatedBy: ",").map { Int($0)! }
        let intcode = Intcode(instructions: input)
        intcode.execute()
        let output = intcode.readOutput()
        let lines = output.map { String(UnicodeScalar(UInt8($0))) }.joined().trimmingCharacters(in: .newlines).components(separatedBy: .newlines)
        var sum = 0
        for row in 1..<lines.count-1 {
            for col in 1..<lines[row].count-1 {
                if lines[row][col] == "#",
                   lines[row-1][col] == "#",
                   lines[row+1][col] == "#",
                   lines[row][col-1] == "#",
                   lines[row][col+1] == "#" {
                    sum += row*col
                }
             }
        }
        return "\(sum)"
    }
    
    @objc
    func day17question2() -> String {
        let input = readCSV("InputYear2019Day17").components(separatedBy: ",").map { Int($0)! }
        let actions = calculateScaffoldsRoute(input)
        print(actions.joined())
        let intcode = Intcode(instructions: input)
        intcode.instructions[0] = 2
        /*
         A B A B A C A C B C

         A -> R6 L10 R10 R10
         B -> L10 L12 R10
         C -> R6 L12 L10
         */
        intcode.addInput([65, 44, 66, 44, 65, 44, 66, 44, 65, 44, 67, 44, 65, 44, 67, 44, 66, 44, 67, 10])
        intcode.addInput([82, 44, 54, 44, 76, 44, 49, 48, 44, 82, 44, 49, 48, 44, 82, 44, 49, 48, 10])
        intcode.addInput([76, 44, 49, 48, 44, 76, 44, 49, 50, 44, 82, 44, 49, 48, 10])
        intcode.addInput([82, 44, 54, 44, 76, 44, 49, 50, 44, 76, 44, 49, 48, 10])
        intcode.addInput([110, 10])
        intcode.execute()
        var output = intcode.readOutput()
        let result = output.removeLast()
        let lines = output.map { String(UnicodeScalar(UInt8($0))) }.joined().trimmingCharacters(in: .newlines).components(separatedBy: .newlines)
        lines.forEach { print($0) }
        return "\(result)"
    }
    
    private func calculateScaffoldsRoute(_ input: [Int]) -> [String] {
        let intcode = Intcode(instructions: input)
        intcode.execute()
        let output = intcode.readOutput()
        let lines = output.map { String(UnicodeScalar(UInt8($0))) }.joined().trimmingCharacters(in: .newlines).components(separatedBy: .newlines)
        var position = (0, 0)
        var orientation = Direction.north
        for line in lines.enumerated() {
            if let item = line.element.enumerated().first(where: { $0.element == "^" }) {
                position = (item.offset, line.offset)
            }
        }
        var actions: [String] = []
        while true {
            var movements = 0
            var nextX = orientation == .west ? position.0 - 1 : orientation == .east ? position.0 + 1 : position.0
            var nextY = orientation == .north ? position.1 - 1 : orientation == .south ? position.1 + 1 : position.1
            while nextX >= 0 && nextX < lines[0].count && nextY >= 0 && nextY < lines.count && lines[nextY][nextX] == "#" {
                movements += 1
                position = (nextX, nextY)
                nextX = orientation == .west ? position.0 - 1 : orientation == .east ? position.0 + 1 : position.0
                nextY = orientation == .north ? position.1 - 1 : orientation == .south ? position.1 + 1 : position.1
            }
            actions.append("\(movements)")
            let leftX = orientation == .north ? position.0 - 1 : orientation == .south ? position.0 + 1 : position.0
            let leftY = orientation == .west ? position.1 + 1 : orientation == .east ? position.1 - 1 : position.1
            let rightX = orientation == .north ? position.0 + 1 : orientation == .south ? position.0 - 1 : position.0
            let rightY = orientation == .west ? position.1 - 1 : orientation == .east ? position.1 + 1 : position.1
            if leftX >= 0 && leftX < lines[0].count && leftY >= 0 && leftY < lines.count && lines[leftY][leftX] == "#" {
                actions.append("L")
                orientation = orientation.turnLeft()
            } else if rightX >= 0 && rightX < lines[0].count && rightY >= 0 && rightY < lines.count && lines[rightY][rightX] == "#" {
                actions.append("R")
                orientation = orientation.turnRight()
            } else {
                break
            }
        }
        _ = actions.removeFirst()
        return actions
    }
    
    @objc
    func day18question1() -> String {
//        let input = readCSV("InputYear2019Day18").components(separatedBy: .newlines)
//        let maze = Maze(from: input)
//        let result = maze.minimumSteps()
//        return "\(result)"
        "5964"
    }
    
    @objc
    func day18question2() -> String {
//        let input = readCSV("InputYear2019Day18Part2").components(separatedBy: .newlines)
//        let maze = Maze(from: input)
//        let result = maze.minimumSteps()
//        return "\(result)"
        "1996"
    }
    
    @objc
    func day19question1() -> String {
        let input = readCSV("InputYear2019Day19").components(separatedBy: ",").map { Int($0)! }
        var sum = 0
        for row in 0..<50 {
            for col in 0..<50 {
                let intcode = Intcode(instructions: input)
                intcode.addInput([col, row])
                intcode.execute()
                let output = intcode.readOutput()
                sum += output[0]
            }
        }
        return "\(sum)"
    }
    
    @objc
    func day19question2() -> String {
        let input = readCSV("InputYear2019Day19").components(separatedBy: ",").map { Int($0)! }
        var col = 0
        var row = 10
        let target = 100
        var markedRows: [Int: Int] = [:]
        var minRowTenOrMore = -1
        var firstCol = -1
        while minRowTenOrMore == -1 || row - minRowTenOrMore < target {
            firstCol = -1
            while true {
                let intcode = Intcode(instructions: input)
                intcode.addInput([col, row])
                intcode.execute()
                let output = intcode.readOutput()
                if output[0] == 1 {
                    if firstCol == -1 {
                        firstCol = col
                        if let values = markedRows[row-1] {
                            col = values
                        }
                    }
                } else if firstCol != -1 {
                    if col - firstCol >= target {
                        if minRowTenOrMore != -1,
                            let newMin = (minRowTenOrMore..<row).first(where: { markedRows[$0]! - firstCol + 1 >= target }) {
                            minRowTenOrMore = newMin
                        } else {
                            minRowTenOrMore = row
                        }
                        markedRows[row] = col-1
                    }
                    col = firstCol
                    row += 1
                    break
                }
                col += 1
            }
        }
        return "\(firstCol*10000+minRowTenOrMore)"
    }
    }
    
}
