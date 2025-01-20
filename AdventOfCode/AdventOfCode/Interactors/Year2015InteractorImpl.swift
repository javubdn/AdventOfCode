//
//  Year2015InteractorImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 20/12/21.
//

import Foundation

class Year2015InteractorImpl: NSObject {
    var wires7: [String: UInt16] = [:]
    var minManaSpent = Int.max
    var gameStatusList: [GameStatus] = []
}

extension Year2015InteractorImpl: YearInteractor {

}

private extension Year2015InteractorImpl {
    
    //MARK: - Main methods
    
    @objc
    func day1question1() -> String {
        let input = readCSV("InputYear2015Day1")
        var floor = 0
        input.forEach { floor += String($0) == "(" ? 1 : -1 }
        return String(floor)
    }
    
    @objc
    func day1question2() -> String {
        let input = readCSV("InputYear2015Day1")
        var floor = 0
        for step in 0..<input.count {
            floor += String(input[step]) == "(" ? 1 : -1
            if floor == -1 { return String(step + 1) }
        }
        return "Error"
    }
    
    @objc
    func day2question1() -> String {
        let input = readCSV("InputYear2015Day2")
            .components(separatedBy: "\n")
            .map{ $0.components(separatedBy: "x")
                .map{ Int($0)! } }
        var total = 0
        input.forEach { values in
            let l = values[0]
            let w = values[1]
            let h = values[2]
            let sortedValues = [l, w, h].sorted()
            total += 2*l*w + 2*w*h + 2*h*l + sortedValues[0]*sortedValues[1]
        }
        return String(total)
    }
    
    @objc
    func day2question2() -> String {
        let input = readCSV("InputYear2015Day2")
            .components(separatedBy: "\n")
            .map{ $0.components(separatedBy: "x")
                .map{ Int($0)! } }
        var total = 0
        input.forEach { values in
            let l = values[0]
            let w = values[1]
            let h = values[2]
            let sortedValues = [l, w, h].sorted()
            total += l*w*h + 2*(sortedValues[0]+sortedValues[1])
        }
        return String(total)
    }
    
    @objc
    func day3question1() -> String {
        let input = readCSV("InputYear2015Day3")
        var visitedHouses: Set = [[0, 0]]
        var currentHouse = [0, 0]
        input.forEach { item in
            switch item {
            case ">":
                currentHouse = [currentHouse[0] + 1, currentHouse[1]]
                visitedHouses.insert(currentHouse)
            case "<":
                currentHouse = [currentHouse[0] - 1, currentHouse[1]]
                visitedHouses.insert(currentHouse)
            case "v":
                currentHouse = [currentHouse[0], currentHouse[1] + 1]
                visitedHouses.insert(currentHouse)
            case "^":
                currentHouse = [currentHouse[0], currentHouse[1] - 1]
                visitedHouses.insert(currentHouse)
            default:
                break
            }
        }
        return String(visitedHouses.count)
    }
    
    @objc
    func day3question2() -> String {
        let input = readCSV("InputYear2015Day3")
        var visitedHouses: Set = [[0, 0]]
        var currentSanta = [0, 0]
        var currentRoboSanta = [0, 0]
        var santa = true
        input.forEach { item in
            switch item {
            case ">":
                if santa {
                    currentSanta = [currentSanta[0] + 1, currentSanta[1]]
                    visitedHouses.insert(currentSanta)
                } else {
                    currentRoboSanta = [currentRoboSanta[0] + 1, currentRoboSanta[1]]
                    visitedHouses.insert(currentRoboSanta)
                }
            case "<":
                if santa {
                    currentSanta = [currentSanta[0] - 1, currentSanta[1]]
                    visitedHouses.insert(currentSanta)
                } else {
                    currentRoboSanta = [currentRoboSanta[0] - 1, currentRoboSanta[1]]
                    visitedHouses.insert(currentRoboSanta)
                }
            case "v":
                if santa {
                    currentSanta = [currentSanta[0], currentSanta[1] + 1]
                    visitedHouses.insert(currentSanta)
                } else {
                    currentRoboSanta = [currentRoboSanta[0], currentRoboSanta[1] + 1]
                    visitedHouses.insert(currentRoboSanta)
                }
            case "^":
                if santa {
                    currentSanta = [currentSanta[0], currentSanta[1] - 1]
                    visitedHouses.insert(currentSanta)
                } else {
                    currentRoboSanta = [currentRoboSanta[0], currentRoboSanta[1] - 1]
                    visitedHouses.insert(currentRoboSanta)
                }
            default:
                break
            }
            santa = !santa
        }
        return String(visitedHouses.count)
    }
    
    @objc
    func day4question1() -> String {
//        let input = "yzbqklnj"
//        var item = 1
//        while true {
//            let value = input + String(item)
//            let prefix = value.MD5String()
//            if  String(prefix) == "00000" {
//                return String(item)
//            }
//            item += 1
//        }
        return "282749"
    }
    
    @objc
    func day4question2() -> String {
//        let input = "yzbqklnj"
//        var item = 1
//        while true {
//            let value = input + String(item)
//            let prefix = value.MD5String()
//            if  String(prefix) == "000000" {
//                return String(item)
//            }
//            item += 1
//        }
        return "9962624"
    }
    
    @objc
    func day5question1() -> String {
        let input = readCSV("InputYear2015Day5")
            .components(separatedBy: "\n")
        let result = input.filter { isNice($0) }.count
        return String(result)
    }
    
    @objc
    func day5question2() -> String {
        let input = readCSV("InputYear2015Day5")
            .components(separatedBy: "\n")
        let result = input.filter { isNiceImproved($0) }.count
        return String(result)
    }
    
    func isNice(_ input: String) -> Bool {
        var nice = false
        let vowels = ["a", "e", "i", "o", "u"]
        let disallowedSubstrings = ["ab", "cd", "pq", "xy"]
        nice = input.filter{ vowels.contains(String($0)) }.count >= 3
        disallowedSubstrings.forEach { item in
            nice = nice && !input.contains(item)
        }
        var found = false
        input.enumerated().forEach { item in
            if item.0 < input.count - 1 {
                if item.1 == input[item.0+1] {
                    found = true
                }
            }
        }
        return nice && found
    }
    
    func isNiceImproved(_ input: String) -> Bool {
        var nice = false
        
        var found = false
        input.enumerated().forEach { item in
            if item.0 < input.count - 2 {
                if item.1 == input[item.0+2] {
                    found = true
                }
            }
        }
        
        for index in 0..<input.count-1 {
            let value = String(input[index...index+1])
            var count = 0
            var index2 = 0
            while index2 < input.count-1 {
                if String(input[index2...index2+1]) == value {
                    count += 1
                    index2 += 1
                }
                if count >= 2 {
                    nice = true
                    break
                }
                index2 += 1
            }
        }
        
        return nice && found
    }
    
    @objc
    func day6question1() -> String {
//        let input = readCSV("InputYear2015Day6")
//            .components(separatedBy: "\n")
//        let instructions = input.map { getInstructionLight(from: $0) }
//        var lights = [[Bool]](repeating: [Bool](repeating: false, count: 1000), count: 1000)
//        instructions.forEach { lights = applyLightInstruction(lights, $0) }
//        let result = lights.map { $0.filter{ $0 }.count }.reduce(0, +)
//        return String(result)
        return "569999"
    }
    
    @objc
    func day6question2() -> String {
//        let input = readCSV("InputYear2015Day6")
//            .components(separatedBy: "\n")
//        let instructions = input.map { getInstructionLight(from: $0) }
//        var lights = [[Int]](repeating: [Int](repeating: 0, count: 1000), count: 1000)
//        instructions.forEach { lights = applyRealLightInstruction(lights, $0) }
//        let result = lights.map { $0.reduce(0, +) }.reduce(0, +)
//        return String(result)
        return "17836115"
    }
    
    enum LightInstruction{
        case turnOn
        case turnOff
        case toggle
    }
    
    struct InstructionForLights {
        let instruction: LightInstruction
        let initX: Int
        let endX: Int
        let initY: Int
        let endY: Int
    }
    
    func getInstructionLight(from input: String) -> InstructionForLights {
        let items = input.components(separatedBy: .whitespaces)
        let coordinateInit: [Int]
        let coordinateEnd: [Int]
        let instruction: LightInstruction
        if items.count == 5 {
            coordinateInit = items[2].components(separatedBy: ",").map { Int($0)! }
            coordinateEnd = items[4].components(separatedBy: ",").map { Int($0)! }
            instruction = items[1] == "on" ? .turnOn : .turnOff
        } else {
            coordinateInit = items[1].components(separatedBy: ",").map { Int($0)! }
            coordinateEnd = items[3].components(separatedBy: ",").map { Int($0)! }
            instruction = .toggle
        }
        return InstructionForLights(instruction: instruction, initX: coordinateInit[0], endX: coordinateEnd[0], initY: coordinateInit[1], endY: coordinateEnd[1])
    }
    
    func applyLightInstruction(_ input: [[Bool]], _ instruction: InstructionForLights) -> [[Bool]] {
        var input = input
        for row in instruction.initY...instruction.endY {
            for column in instruction.initX...instruction.endX {
                switch instruction.instruction {
                case .turnOn: input[row][column] = true
                case .turnOff: input[row][column] = false
                case .toggle: input[row][column] = !input[row][column]
                }
            }
        }
        return input
    }
    
    func applyRealLightInstruction(_ input: [[Int]], _ instruction: InstructionForLights) -> [[Int]] {
        var input = input
        for row in instruction.initY...instruction.endY {
            for column in instruction.initX...instruction.endX {
                switch instruction.instruction {
                case .turnOn: input[row][column] += 1
                case .turnOff:
                    input[row][column] -= 1
                    input[row][column] = input[row][column] < 0 ? 0 : input[row][column]
                case .toggle: input[row][column] += 2
                }
            }
        }
        return input
    }
    
    @objc
    func day7question1() -> String {
        let input = readCSV("InputYear2015Day7")
                    .components(separatedBy: "\n")
        let instructions = input.map { getInstructionWire(from: $0) }
        return String(getSignal(instructions: instructions, wire: "a"))
    }
    
    @objc
    func day7question2() -> String {
        let input = readCSV("InputYear2015Day7")
                    .components(separatedBy: "\n")
        let instructions = input.map { getInstructionWire(from: $0) }
            .map { instruction -> InstructionForWire in
                if instruction.endValue == "b" {
                    return InstructionForWire(instruction: instruction.instruction, firstInitValue: String(UInt16(46065)), secondInitValue: instruction.secondInitValue, endValue: instruction.endValue)
                } else {
                    return instruction
                }
            }
        
        return String(getSignal(instructions: instructions, wire: "a"))
    }
    
    enum WireInstruction{
        case assign
        case and
        case or
        case lShift
        case rShift
        case not
    }
    
    struct InstructionForWire {
        let instruction: WireInstruction
        let firstInitValue: String
        let secondInitValue: String?
        let endValue: String
    }
    
    func getInstructionWire(from input: String) -> InstructionForWire {
        let items = input.components(separatedBy: .whitespaces)
        let instruction: WireInstruction
        let firstInitValue: String
        var secondInitValue: String? = nil
        let endValue: String
        if items.count == 3 {
            firstInitValue = items[0]
            endValue = items[2]
            instruction = .assign
        } else if items.count == 4 {
            firstInitValue = items[1]
            endValue = items[3]
            instruction = .not
        } else {
            firstInitValue = items[0]
            secondInitValue = items[2]
            switch items[1] {
            case "AND": instruction = .and
            case "OR": instruction = .or
            case "LSHIFT": instruction = .lShift
            case "RSHIFT": instruction = .rShift
            default: instruction = .and
            }
            endValue = items[4]
        }
        return InstructionForWire(instruction: instruction, firstInitValue: firstInitValue, secondInitValue: secondInitValue, endValue: endValue)
    }
    
    func getSignal(instructions: [InstructionForWire], wire: String) -> UInt16 {
        if let value = UInt16(wire) { return value }
        if let value = wires7[wire] { return value }
        guard let instruction = instructions.first(where: { $0.endValue == wire }) else { return 0 }
        let result: UInt16
        switch instruction.instruction {
        case .assign:
            if let value = UInt16(instruction.firstInitValue) {
                result = value
            } else {
                result = getSignal(instructions: instructions, wire: instruction.firstInitValue)
            }
        case .not:
            let firstValue = getSignal(instructions: instructions, wire: instruction.firstInitValue)
            result = ~firstValue
        case .and:
            guard let secondInitValue = instruction.secondInitValue else { return 0 }
            let firstValue = getSignal(instructions: instructions, wire: instruction.firstInitValue)
            let secondValue = getSignal(instructions: instructions, wire: secondInitValue)
            result = firstValue&secondValue
        case .or:
            guard let secondInitValue = instruction.secondInitValue else { return 0 }
            let firstValue = getSignal(instructions: instructions, wire: instruction.firstInitValue)
            let secondValue = getSignal(instructions: instructions, wire: secondInitValue)
            result = firstValue|secondValue
        case .lShift:
            guard let secondInitValue = instruction.secondInitValue,
                    let secondValue = UInt16(secondInitValue) else { return 0 }
            let firstValue = getSignal(instructions: instructions, wire: instruction.firstInitValue)
            result = firstValue<<secondValue
        case .rShift:
            guard let secondInitValue = instruction.secondInitValue,
                    let secondValue = UInt16(secondInitValue) else { return 0 }
            let firstValue = getSignal(instructions: instructions, wire: instruction.firstInitValue)
            result = firstValue>>secondValue
        }
        
        wires7[wire] = result
        return result
    }
    
    @objc
    func day8question1() -> String {
        let input = readCSV("InputYear2015Day8")
                    .components(separatedBy: "\n")
        let result = input.map { $0.count - numberCharactersCode(literal: $0) + 2 }.reduce(0, +)
        return String(result)
    }
    
    @objc
    func day8question2() -> String {
        let input = readCSV("InputYear2015Day8")
                    .components(separatedBy: "\n")
        let result = input.map { getNewlyEncodedString($0).count - $0.count + 2 }.reduce(0, +)
        return String(result)
    }
    
    func numberCharactersCode(literal: String) -> Int {
        var result = ""
        var index = 0
        while index < literal.count {
            let currentChar = String(literal[index])
            if currentChar == "\\" {
                if String(literal[index+1]) == "\\" || String(literal[index+1]) == "\"" {
                    result += String(literal[index+1])
                    index += 2
                } else {
                    result += String(UnicodeScalar(Int(String(literal[index+2...index+3]), radix: 16)!)!)
                    index += 4
                }
            } else {
                result += currentChar
                index += 1
            }
        }
        return result.count
    }
    
    func getNewlyEncodedString(_ literal: String) -> String {
        var literal = literal
        literal = literal.replacingOccurrences(of: "\\", with: "\\\\")
        literal = literal.replacingOccurrences(of: "\"", with: "\\\"")
        return literal
    }
    
    @objc
    func day9question1() -> String {
        let input = readCSV("InputYear2015Day9")
                    .components(separatedBy: "\n")
        let journeys = input.map { getJourney($0) }
        let cities = getCities(journeys: journeys)
        var minDistance = Int.max
        cities.forEach { city in
            minDistance = min(minDistance, getDistancePath(minimum: true, journeys: journeys, notVisitedCities: cities, currentCity: city))
        }
        return String(minDistance)
    }
    
    @objc
    func day9question2() -> String {
        let input = readCSV("InputYear2015Day9")
                    .components(separatedBy: "\n")
        let journeys = input.map { getJourney($0) }
        let cities = getCities(journeys: journeys)
        var maxDistance = Int.min
        cities.forEach { city in
            maxDistance = max(maxDistance, getDistancePath(minimum: false, journeys: journeys, notVisitedCities: cities, currentCity: city))
        }
        return String(maxDistance)
    }
    
    struct Journey {
        let initCity: String
        let endCity: String
        let distance: Int
    }
    
    func getJourney(_ input: String) -> Journey {
        let values = input.components(separatedBy: .whitespaces)
        return Journey(initCity: values[0], endCity: values[2], distance: Int(values[4])!)
    }
    
    func getCities(journeys: [Journey]) -> [String] {
        var cities: Set<String> = Set()
        journeys.forEach { journey in
            cities.insert(journey.initCity)
            cities.insert(journey.endCity)
        }
        return Array(cities)
    }
    
    func getDistancePath(minimum: Bool, journeys: [Journey], notVisitedCities: [String], currentCity: String) -> Int {
        if notVisitedCities.count == 1 {
            return 0
        }
        var notVisitedCities = notVisitedCities
        notVisitedCities.removeAll { $0 == currentCity }
        var currentDistance = minimum ? Int.max : Int.min
        let nextJourneys = journeys.filter { ($0.initCity == currentCity
                                              && notVisitedCities.contains($0.endCity))
            || ($0.endCity == currentCity
                && notVisitedCities.contains($0.initCity)) }
        nextJourneys.forEach { journey in
            let distance = getDistancePath(minimum: minimum,
                                           journeys: journeys,
                                           notVisitedCities: notVisitedCities,
                                           currentCity: journey.initCity == currentCity ? journey.endCity : journey.initCity)
            currentDistance = minimum ? min(currentDistance, distance + journey.distance) : max(currentDistance, distance + journey.distance)
        }
        return currentDistance
    }
    
    @objc
    func day10question1() -> String {
//        let input = "3113322113"
//        var result: [Int] = input.map { Int(String($0))!}
//        for _ in 0..<40 {
//            result = lookAndSay(result)
//        }
//        return String(result.count)
        return "329356"
    }
    
    @objc
    func day10question2() -> String {
//        let input = "3113322113"
//        var result: [Int] = input.map { Int(String($0))!}
//        for _ in 0..<50 {
//            result = lookAndSay(result)
//        }
//        return String(result.count)
        return "4666278"
    }
    
    func lookAndSay(_ input: [Int]) -> [Int] {
        var result = [Int]()
        var currentItem = input[0]
        var currentLength = 1
     
        for item in input.dropFirst() {
            if currentItem == item {
                currentLength += 1
            } else {
                result.append(currentLength)
                result.append(currentItem)
                currentLength = 1
                currentItem = item
            }
        }
    
        result.append(currentLength)
        result.append(currentItem)
     
        return result
    }
    
    @objc
    func day11question1() -> String {
//        let input = "vzbxkghb"
//        return nextValidPassword(input)
        return "vzbxxyzz"
    }
    
    @objc
    func day11question2() -> String {
//        let input = "vzbxxyzz"
//        return nextValidPassword(input)
        return "vzcaabcc"
    }
    
    func nextValidPassword(_ input: String) -> String {
        var result = nextPassword(input, previousValid: rulesPass(input))
        var valid = rulesPass(result)
        while !valid {
            result = nextPasswordNoInvalidChars(result, previousValid: false)
            valid = rulesPass(result)
        }
        return result
    }
    
    func nextPassword(_ input: String, previousValid: Bool) -> String {
        let nextSpecialChars = ["i": "j", "l": "m", "o": "p"]
        var index = 0
        while index < input.count {
            if input[index] == "i" || input[index] == "o" || input[index] == "l" {
                return String(input[0..<index]) + nextSpecialChars[String(input[index])]! + [String](repeating: "a", count: input.count-index-1).joined()
            }
            index += 1
        }
        return nextPasswordNoInvalidChars(input, previousValid: previousValid)
    }
    
    func nextPasswordNoInvalidChars(_ input: String, previousValid: Bool) -> String {
        let chars = "abcdefghjkmnpqrstuvwxyz"
        var result = input
        if result.last! == "z" {
            result = nextPasswordNoInvalidChars(String(result[0...result.count-2]), previousValid: true) + "a"
        } else if previousValid || result.last! == result[result.count-2] {
            let currentIndex = chars.firstIndex(of: result.last!)!
            let nextIndex = chars.index(currentIndex, offsetBy: 1)
            result = String(result[0...result.count-2]) + chars[nextIndex...nextIndex]
        } else if result.last! < result[result.count-2] {
            result = String(result[0...result.count-2]) + String(result[result.count-2])
        } else {
            result = nextPasswordNoInvalidChars(String(result[0...result.count-2]), previousValid: true) + "a"
        }
        return result
    }
    
    func rulesPass(_ input: String) -> Bool {
        if input.contains("i") || input.contains("o") || input.contains("l") { return false }
        var rule1 = false
        for index in 0..<input.count-3 {
            if "abcdefgh".contains(String(input[index...index+2]))
                || "pqrstuvwxyz".contains(String(input[index...index+2])) {
                rule1 = true
                break
            }
        }
        if !rule1 { return false }
        var index = 0
        var count = 0
        while index < input.count-1 {
            if input[index] == input[index+1] {
                count += 1
                index += 2
            } else {
                index += 1
            }
        }
        return count >= 2
    }
    
    @objc
    func day12question1() -> String {
        let input = readCSV("InputYear2015Day12")
        let result = sumIntsInString(input)
        return String(result)
    }
    
    @objc
    func day12question2() -> String {
        let input = readCSV("InputYear2015Day12")
        let result = sumIntsInString(removeRedStructures(input))
        return String(result)
    }
    
    func sumIntsInString(_ input: String) -> Int {
        do {
            let regex = try NSRegularExpression(pattern: #"([0-9-]+)"#)
            var sum = 0
            regex.enumerateMatches(in: input, range: NSRange(input.startIndex..., in: input)) { result, _, _ in
                sum += Int(input[Range(result!.range, in: input)!])!
            }
            return sum
        } catch _ {
            return 0
        }
    }
    
    func removeRedStructures(_ input: String) -> String {
        var input = input
        let regex = try! NSRegularExpression(pattern: #"([{}\[\]])"#)
        var left: [NSRange] = []
        regex.enumerateMatches(in: input, range: NSRange(input.startIndex..., in: input)) { result, _, _ in
            guard let range = result?.range else { return }
            let value = input[Range(range, in: input)!]
            if value == "{" || value == "[" {
                left.append(range)
            } else {
                let rangeLeft = left.popLast()!
                let newRange = NSRange(location: rangeLeft.location, length: range.location + 1 - rangeLeft.location)
                let range = Range(newRange, in: input)
                if input[Range(rangeLeft, in: input)!] == "{" {
                    if input[range!].contains("red") {
                        let text = String(repeating: "X", count: newRange.length)
                        input = input.replacingCharacters(in: range!, with: text)
                    }
                } else {
                    input = input.replacingOccurrences(of: "red", with: "XXX", range: range)
                }
            }
        }
        
        return input
    }
    
    @objc
    func day13question1() -> String {
//        let input = readCSV("InputYear2015Day13")
//        let hapinessList = input
//            .components(separatedBy: "\n")
//            .map { getHapiness($0) }
//        var bestResult = Int.min
//        let perm = pseudoPermutations(getGuests(from: hapinessList))
//        perm.forEach { guests in
//            let firstGuest = guests.first!
//            let result = getBestGuestCombination(hapinessList: hapinessList, notAnalisedGuest: guests, currentGuest: firstGuest)
//            bestResult = max(bestResult, result.1)
//        }
//        return String(bestResult)
        return "618"
        //(["Bob", "Eric", "Alice", "Frank", "Mallory", "George", "David", "Carol"], 618)
    }
    
    @objc
    func day13question2() -> String {
//        let input = readCSV("InputYear2015Day13")
//        var hapinessList = input
//            .components(separatedBy: "\n")
//            .map { getHapiness($0) }
//        var currentGuests = getGuests(from: hapinessList)
//        for currentGuest in currentGuests {
//            hapinessList.append(Hapiness(person1: "YO", person2: currentGuest, hapiness: 0))
//            hapinessList.append(Hapiness(person1: currentGuest, person2: "YO", hapiness: 0))
//        }
//        currentGuests.append("YO")
//        var bestResult = Int.min
//        let perm = pseudoPermutations(currentGuests)
//        perm.forEach { guests in
//            let firstGuest = guests.first!
//            let result = getBestGuestCombination(hapinessList: hapinessList, notAnalisedGuest: guests, currentGuest: firstGuest)
//            bestResult = max(bestResult, result.1)
//        }
//        return String(bestResult)
        return "601"
    }
    
    struct Hapiness {
        let person1: String
        let person2: String
        let hapiness: Int
    }
    
    func getHapiness(_ input: String) -> Hapiness {
        let items = input.components(separatedBy: .whitespaces)
        return Hapiness(person1: items[0], person2: items[10], hapiness: Int(items[3])! * (items[2] == "gain" ? 1 : -1) )
    }
    
    func getGuests(from hapinessList: [Hapiness]) -> [String] {
        var guests: Set<String> = Set()
        hapinessList.forEach { hapiness in
            guests.insert(hapiness.person1)
            guests.insert(hapiness.person2)
        }
        return Array(guests)
    }
    
    func getBestGuestCombination(hapinessList: [Hapiness], notAnalisedGuest: [String], currentGuest: String) -> ([String], Int) {
        if notAnalisedGuest.count == 3 {
            let items = hapinessList.filter { notAnalisedGuest.contains($0.person1) && notAnalisedGuest.contains($0.person2) }
            return (notAnalisedGuest, items.map { $0.hapiness }.reduce(0, +))
        }
        var notAnalisedGuest = notAnalisedGuest
        notAnalisedGuest.removeAll { $0 == currentGuest }
        
        var bestCombinationWithoutMe = getBestGuestCombination(hapinessList: hapinessList,
                                                               notAnalisedGuest: notAnalisedGuest,
                                                               currentGuest: notAnalisedGuest.first!)
        let firstGuest = hapinessList.filter { ($0.person1 == currentGuest && $0.person2 == bestCombinationWithoutMe.0.first!)
            || ($0.person2 == currentGuest && $0.person1 == bestCombinationWithoutMe.0.first!)
        }.map { $0.hapiness }.reduce(0, +)
        let secondGuest = hapinessList.filter { ($0.person1 == currentGuest && $0.person2 == bestCombinationWithoutMe.0.last!)
            || ($0.person2 == currentGuest && $0.person1 == bestCombinationWithoutMe.0.last!)
        }.map { $0.hapiness }.reduce(0, +)
        let previousGuests = hapinessList.filter { ($0.person1 == bestCombinationWithoutMe.0.first! && $0.person2 == bestCombinationWithoutMe.0.last!)
            || ($0.person2 == bestCombinationWithoutMe.0.first! && $0.person1 == bestCombinationWithoutMe.0.last!)
        }.map { $0.hapiness }.reduce(0, +)
        var currentHapinessGain = firstGuest + secondGuest - previousGuests
        var bestPosition = bestCombinationWithoutMe.0.count
        for index in 0..<bestCombinationWithoutMe.0.count - 1 {
            let firstGuest = hapinessList.filter { ($0.person1 == currentGuest && $0.person2 == bestCombinationWithoutMe.0[index])
                || ($0.person2 == currentGuest && $0.person1 == bestCombinationWithoutMe.0[index])
            }.map { $0.hapiness }.reduce(0, +)
            let secondGuest = hapinessList.filter { ($0.person1 == currentGuest && $0.person2 == bestCombinationWithoutMe.0[index+1])
                || ($0.person2 == currentGuest && $0.person1 == bestCombinationWithoutMe.0[index+1])
            }.map { $0.hapiness }.reduce(0, +)
            let previousGuests = hapinessList.filter { ($0.person1 == bestCombinationWithoutMe.0[index] && $0.person2 == bestCombinationWithoutMe.0[index+1])
                || ($0.person2 == bestCombinationWithoutMe.0[index] && $0.person1 == bestCombinationWithoutMe.0[index+1])
            }.map { $0.hapiness }.reduce(0, +)
            if currentHapinessGain < firstGuest + secondGuest - previousGuests {
                currentHapinessGain = firstGuest + secondGuest - previousGuests
                bestPosition = index+1
            }
        }
        bestCombinationWithoutMe.0.insert(currentGuest, at: bestPosition)
        return (bestCombinationWithoutMe.0, currentHapinessGain + bestCombinationWithoutMe.1)
    }
    
    func pseudoPermutations(_ input: [String]) -> [[String]] {
        guard input.count > 2 else { return [] }
        let variations = Utils.variations(elements: input, k: input.count-3)
        
        let result = variations.map { variation -> [String] in
            let notContainedItems = input.filter { !variation.contains($0) }
            return variation+notContainedItems
        }
        return result
    }
    
    @objc
    func day14question1() -> String {
        let input = readCSV("InputYear2015Day14")
        let reindeers = input.components(separatedBy: "\n")
            .map { getReindeer($0) }
        var maxDistance = Int.min
        reindeers.forEach { maxDistance = max(maxDistance, getDistance(reindeer: $0, time: 2503)) }
        return String(maxDistance)
    }
    
    @objc
    func day14question2() -> String {
        let input = readCSV("InputYear2015Day14")
        let reindeers = input.components(separatedBy: "\n")
            .map { getReindeer($0) }
        
        var points: [String: (Int, Int)] = [:]
        reindeers.forEach { points[$0.name] = (0, 0) }
        var maxValue =  0
        for time in 0..<2503 {
            for reindeer in reindeers {
                if time % (reindeer.runTime + reindeer.restTime) < reindeer.runTime {
                    let newDistance = points[reindeer.name]!.0 + reindeer.speed
                    points[reindeer.name] = (newDistance, points[reindeer.name]!.1)
                    maxValue = max(maxValue, newDistance)
                }
            }
            let currentWinners = reindeers.filter { points[$0.name]!.0 == maxValue }
            currentWinners.forEach { points[$0.name] = (points[$0.name]!.0, points[$0.name]!.1 + 1) }
        }
        
        let result = points.reduce(into: 0) { partialResult, currentItem in
            partialResult = max(currentItem.value.1, partialResult)
        }
        return String(result)
    }
    
    struct Reindeer {
        let name: String
        let speed: Int
        let runTime: Int
        let restTime: Int
    }
    
    func getReindeer(_ input: String) -> Reindeer {
        let items = input.components(separatedBy: .whitespaces)
        return Reindeer(name: items[0], speed: Int(items[3])!, runTime: Int(items[6])!, restTime: Int(items[13])!)
    }
    
    func getDistance(reindeer: Reindeer, time: Int) -> Int {
        let runAndRest = reindeer.runTime + reindeer.restTime
        let timesRunAndRest = time / runAndRest
        let lackTime = time % runAndRest
        var distanceRunAndRest = timesRunAndRest * reindeer.speed * reindeer.runTime
        distanceRunAndRest += reindeer.speed * min(lackTime, reindeer.runTime)
        return distanceRunAndRest
    }
    
    @objc
    func day15question1() -> String {
//        let input = readCSV("InputYear2015Day15")
//        let ingredients = input.components(separatedBy: "\n")
//            .map { getIngredient($0) }
//        let combinations = Utils.combinations(100, in: 4)
//        var bestValue = Int.min
//        combinations.forEach {
//            bestValue = max(bestValue, combinationValueCalories(ingredients: ingredients, values: $0).0 )
//        }
//        return String(bestValue)
        return "222870"
    }
    
    @objc
    func day15question2() -> String {
//        let input = readCSV("InputYear2015Day15")
//        let ingredients = input.components(separatedBy: "\n")
//            .map { getIngredient($0) }
//        let combinations = Utils.combinations(100, in: 4)
//        var bestValue = Int.min
//        combinations.forEach { item in
//            let combination = combinationValueCalories(ingredients: ingredients, values: item)
//            if combination.1 == 500 {
//                bestValue = max(bestValue, combination.0)
//            }
//        }
//        return String(bestValue)
        return "117936"
    }
    
    struct Ingredient {
        let name: String
        let capacity: Int
        let durability: Int
        let flavor: Int
        let texture: Int
        let calories: Int
    }
    
    func getIngredient(_ input: String) -> Ingredient {
        let items = input.components(separatedBy: .whitespaces)
        return Ingredient(name: items[0], capacity: Int(items[2])!, durability: Int(items[4])!, flavor: Int(items[6])!, texture: Int(items[8])!, calories: Int(items[10])!)
    }
    
    func combinationValueCalories(ingredients: [Ingredient], values: [Int]) -> (Int, Int) {
        guard values.count == ingredients.count else { return (0, 0) }
        var capacity = 0
        var durability = 0
        var flavor = 0
        var texture = 0
        var calories = 0
        ingredients.enumerated().forEach { item in
            capacity += item.1.capacity * values[item.0]
            durability += item.1.durability * values[item.0]
            flavor += item.1.flavor * values[item.0]
            texture += item.1.texture * values[item.0]
            calories += item.1.calories * values[item.0]
        }
        capacity = max(0, capacity)
        durability = max(0, durability)
        flavor = max(0, flavor)
        texture = max(0, texture)
        return (capacity*durability*flavor*texture, calories)
    }
    
    @objc
    func day16question1() -> String {
        let input = readCSV("InputYear2015Day16")
        let auntSues = input.components(separatedBy: "\n")
                        .map { getAuntSue($0) }
        let expectedSue = AuntSue(number: -1, children: 3, cats: 7, samoyeds: 2, pomeranians: 3, akitas: 0, vizslas: 0, goldfish: 5, trees: 3, cars: 2, perfumes: 1)
        var result = -1
        auntSues.forEach { auntSue in
            if auntSue.children == nil || auntSue.children == expectedSue.children,
               auntSue.cats == nil || auntSue.cats == expectedSue.cats,
               auntSue.samoyeds == nil || auntSue.samoyeds == expectedSue.samoyeds,
               auntSue.pomeranians == nil || auntSue.pomeranians == expectedSue.pomeranians,
               auntSue.akitas == nil || auntSue.akitas == expectedSue.akitas,
               auntSue.vizslas == nil || auntSue.vizslas == expectedSue.vizslas,
               auntSue.goldfish == nil || auntSue.goldfish == expectedSue.goldfish,
               auntSue.trees == nil || auntSue.trees == expectedSue.trees,
               auntSue.cars == nil || auntSue.cars == expectedSue.cars,
               auntSue.perfumes == nil || auntSue.perfumes == expectedSue.perfumes {
                result = auntSue.number
            }
        }
        return String(result)
    }
    
    @objc
    func day16question2() -> String {
        let input = readCSV("InputYear2015Day16")
        let auntSues = input.components(separatedBy: "\n")
                        .map { getAuntSue($0) }
        let expectedSue = AuntSue(number: -1, children: 3, cats: 7, samoyeds: 2, pomeranians: 3, akitas: 0, vizslas: 0, goldfish: 5, trees: 3, cars: 2, perfumes: 1)
        var result = -1
        auntSues.forEach { auntSue in
            if auntSue.children == nil || auntSue.children == expectedSue.children,
               auntSue.cats == nil || auntSue.cats! > expectedSue.cats!,
               auntSue.samoyeds == nil || auntSue.samoyeds == expectedSue.samoyeds,
               auntSue.pomeranians == nil || auntSue.pomeranians! < expectedSue.pomeranians!,
               auntSue.akitas == nil || auntSue.akitas == expectedSue.akitas,
               auntSue.vizslas == nil || auntSue.vizslas == expectedSue.vizslas,
               auntSue.goldfish == nil || auntSue.goldfish! < expectedSue.goldfish!,
               auntSue.trees == nil || auntSue.trees! > expectedSue.trees!,
               auntSue.cars == nil || auntSue.cars == expectedSue.cars,
               auntSue.perfumes == nil || auntSue.perfumes == expectedSue.perfumes {
                result = auntSue.number
            }
        }
        return String(result)
    }
    
    struct AuntSue {
        let number: Int
        let children: Int?
        let cats: Int?
        let samoyeds: Int?
        let pomeranians: Int?
        let akitas: Int?
        let vizslas: Int?
        let goldfish: Int?
        let trees: Int?
        let cars: Int?
        let perfumes: Int?
    }
    
    func getAuntSue(_ input: String) -> AuntSue {
        let items = input.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ":", with: "").components(separatedBy: .whitespaces)
        let sueNumber = Int(items[1])!
        
        var values: [String: Int] = [:]
        var index = 2
        while index < items.count {
            values[items[index]] = Int(items[index+1])!
            index += 2
        }
        return AuntSue(number: sueNumber, children: values["children"], cats: values["cats"], samoyeds: values["samoyeds"], pomeranians: values["pomeranians"], akitas: values["akitas"], vizslas: values["vizslas"], goldfish: values["goldfish"], trees: values["trees"], cars: values["cars"], perfumes: values["perfumes"])
    }
    
    @objc
    func day17question1() -> String {
//        let input = [43, 3, 4, 10, 21, 44, 4, 6, 47, 41, 34, 17, 17, 44, 36, 31, 46, 9, 27, 38]
//        let target = 150
//        let result = Utils.clusters(input).filter { $0.reduce(0, +) == target }.count
//        return String(result)
        return "1638"
    }
    
    @objc
    func day17question2() -> String {
//        let input = [43, 3, 4, 10, 21, 44, 4, 6, 47, 41, 34, 17, 17, 44, 36, 31, 46, 9, 27, 38]
//        let target = 150
//        let result = Utils.clusters(input).filter { $0.reduce(0, +) == target && $0.count == 4 }.count
//        return String(result)
        return "17"
    }
    
    @objc
    func day18question1() -> String {
//        let input = readCSV("InputYear2015Day18").components(separatedBy: "\n")
//            .map { Array($0).map { String($0) } }
//        var result = input
//        for _ in 1...100 {
//            var newResult = [[String]](repeating: [String](repeating: "", count: result[0].count), count: result.count)
//            for row in 0..<result.count {
//                for column in 0..<result[0].count {
//                    var countOn = 0
//                    countOn += column == result[0].count-1 ? 0 : result[row][column+1] == "#" ? 1 : 0
//                    countOn += column == 0 ? 0 : result[row][column-1] == "#" ? 1 : 0
//                    countOn += row == result.count-1 ? 0 : result[row+1][column] == "#" ? 1 : 0
//                    countOn += row == 0 ? 0 : result[row-1][column] == "#" ? 1 : 0
//                    countOn += (row == result.count-1 || column == result[0].count-1) ? 0 : result[row+1][column+1] == "#" ? 1 : 0
//                    countOn += (row == 0 || column == 0) ? 0 : result[row-1][column-1] == "#" ? 1 : 0
//                    countOn += (row == result.count-1 || column == 0) ? 0 : result[row+1][column-1] == "#" ? 1 : 0
//                    countOn += (row == 0 || column == result[0].count-1) ? 0 : result[row-1][column+1] == "#" ? 1 : 0
//                    if result[row][column] == "#" {
//                        newResult[row][column] = (countOn == 2 || countOn == 3) ? "#" : "."
//                    } else {
//                        newResult[row][column] = (countOn == 3) ? "#" : "."
//                    }
//                }
//            }
//            result = newResult
//        }
//        return String(result.map { $0.filter { $0 == "#" }.count }.reduce(0, +))
        return "821"
    }
    
    @objc
    func day18question2() -> String {
//        let input = readCSV("InputYear2015Day18").components(separatedBy: "\n")
//            .map { Array($0).map { String($0) } }
//        var result = input
//        result[0][0] = "#"
//        result[result.count-1][0] = "#"
//        result[0][result[0].count-1] = "#"
//        result[result.count-1][result[0].count-1] = "#"
//        for _ in 1...100 {
//            var newResult = [[String]](repeating: [String](repeating: "", count: result[0].count), count: result.count)
//            for row in 0..<result.count {
//                for column in 0..<result[0].count {
//                    var countOn = 0
//                    countOn += column == result[0].count-1 ? 0 : result[row][column+1] == "#" ? 1 : 0
//                    countOn += column == 0 ? 0 : result[row][column-1] == "#" ? 1 : 0
//                    countOn += row == result.count-1 ? 0 : result[row+1][column] == "#" ? 1 : 0
//                    countOn += row == 0 ? 0 : result[row-1][column] == "#" ? 1 : 0
//                    countOn += (row == result.count-1 || column == result[0].count-1) ? 0 : result[row+1][column+1] == "#" ? 1 : 0
//                    countOn += (row == 0 || column == 0) ? 0 : result[row-1][column-1] == "#" ? 1 : 0
//                    countOn += (row == result.count-1 || column == 0) ? 0 : result[row+1][column-1] == "#" ? 1 : 0
//                    countOn += (row == 0 || column == result[0].count-1) ? 0 : result[row-1][column+1] == "#" ? 1 : 0
//                    if result[row][column] == "#" {
//                        newResult[row][column] = (countOn == 2 || countOn == 3) ? "#" : "."
//                    } else {
//                        newResult[row][column] = (countOn == 3) ? "#" : "."
//                    }
//                }
//            }
//            newResult[0][0] = "#"
//            newResult[result.count-1][0] = "#"
//            newResult[0][result[0].count-1] = "#"
//            newResult[result.count-1][result[0].count-1] = "#"
//            result = newResult
//        }
//        return String(result.map { $0.filter { $0 == "#" }.count }.reduce(0, +))
        return "886"
    }
    
    @objc
    func day19question1() -> String {
        let rules = readCSV("InputYear2015Day19").components(separatedBy: "\n")
            .map { $0.components(separatedBy: " => ") }
        let origin = "ORnPBPMgArCaCaCaSiThCaCaSiThCaCaPBSiRnFArRnFArCaCaSiThCaCaSiThCaCaCaCaCaCaSiRnFYFArSiRnMgArCaSiRnPTiTiBFYPBFArSiRnCaSiRnTiRnFArSiAlArPTiBPTiRnCaSiAlArCaPTiTiBPMgYFArPTiRnFArSiRnCaCaFArRnCaFArCaSiRnSiRnMgArFYCaSiRnMgArCaCaSiThPRnFArPBCaSiRnMgArCaCaSiThCaSiRnTiMgArFArSiThSiThCaCaSiRnMgArCaCaSiRnFArTiBPTiRnCaSiAlArCaPTiRnFArPBPBCaCaSiThCaPBSiThPRnFArSiThCaSiThCaSiThCaPTiBSiRnFYFArCaCaPRnFArPBCaCaPBSiRnTiRnFArCaPRnFArSiRnCaCaCaSiThCaRnCaFArYCaSiRnFArBCaCaCaSiThFArPBFArCaSiRnFArRnCaCaCaFArSiRnFArTiRnPMgArF"
        var combinations: Set<String> = Set()
        rules.forEach { rule in
            let regex = try! NSRegularExpression(pattern: rule[0])
            regex.enumerateMatches(in: origin, range: NSRange(origin.startIndex..., in: origin)) { result, _, _ in
                guard let range = result?.range else { return }
                var origin = origin
                origin = origin.replacingCharacters(in: Range(range, in: origin)!, with: rule[1])
                combinations.insert(origin)
            }
            
        }
        return String(combinations.count)
    }
    
    @objc
    func day19question2() -> String {
        let rules = readCSV("InputYear2015Day19").components(separatedBy: "\n")
            .map { $0.components(separatedBy: " => ") }.map { ($0[0], $0[1]) }
        let medicine = "ORnPBPMgArCaCaCaSiThCaCaSiThCaCaPBSiRnFArRnFArCaCaSiThCaCaSiThCaCaCaCaCaCaSiRnFYFArSiRnMgArCaSiRnPTiTiBFYPBFArSiRnCaSiRnTiRnFArSiAlArPTiBPTiRnCaSiAlArCaPTiTiBPMgYFArPTiRnFArSiRnCaCaFArRnCaFArCaSiRnSiRnMgArFYCaSiRnMgArCaCaSiThPRnFArPBCaSiRnMgArCaCaSiThCaSiRnTiMgArFArSiThSiThCaCaSiRnMgArCaCaSiRnFArTiBPTiRnCaSiAlArCaPTiRnFArPBPBCaCaSiThCaPBSiThPRnFArSiThCaSiThCaSiThCaPTiBSiRnFYFArCaCaPRnFArPBCaCaPBSiRnTiRnFArCaPRnFArSiRnCaCaCaSiThCaRnCaFArYCaSiRnFArBCaCaCaSiThFArPBFArCaSiRnFArRnCaCaCaFArSiRnFArTiRnPMgArF"
        let convertedMedicine = convertMedicine(medicine, rules: rules)
        let numberParentesis = 2 * (convertedMedicine.components(separatedBy:"(").count-1)
        let numberCommas =  convertedMedicine.components(separatedBy:",").count-1
        let solution = convertedMedicine.count - numberParentesis - 2 * numberCommas - 1
        return String(solution)
    }
    
    func convertMedicine(_ medicine: String, rules: [(String, String)]) -> String {
        var convertedMedicine = medicine.replacingOccurrences(of: "Rn", with: "(")
            .replacingOccurrences(of: "Y", with: ",")
            .replacingOccurrences(of: "Ar", with: ")")
        rules.forEach { convertedMedicine = convertedMedicine.replacingOccurrences(of: $0.0, with: "X") }
        return convertedMedicine
    }
    
    @objc
    func day20question1() -> String {
//        let target = 29000000
//        var houseNumber = 1
//        while true {
//            let presents = factors(of: houseNumber).reduce(0, +) * 10
//            if presents >= target {
//                break
//            } else {
//                result += 1
//            }
//        }
//        return String(houseNumber)
        return "665280"
    }
    
    @objc
    func day20question2() -> String {
//        let target = 29000000
//        var houseNumber = 1
//        while true {
//            let presents = factors(of: houseNumber).filter { $0*50 >= houseNumber }.reduce(0, +) * 11
//            if presents >= target {
//                break
//            } else {
//                result += 1
//            }
//        }
//        return String(houseNumber)
        return "705600"
    }
    
    private func factors(of n: Int) -> [Int] {
        precondition(n > 0, "n must be positive")
        let sqrtn = Int(Double(n).squareRoot())
        var factors: [Int] = []
        factors.reserveCapacity(2 * sqrtn)
        for i in 1...sqrtn {
            if n % i == 0 {
                factors.append(i)
            }
        }
        var j = factors.count - 1
        if factors[j] * factors[j] == n {
            j -= 1
        }
        while j >= 0 {
            factors.append(n / factors[j])
            j -= 1
        }
        return factors
    }
    
    @objc
    func day21question1() -> String {
        let minimumPrice = calculateBestPriceDefault(true)
        return String(minimumPrice)
    }
    
    @objc
    func day21question2() -> String {
        let maximumPrice = calculateBestPriceDefault(false)
        return String(maximumPrice)
    }
    
    struct GameCharacter {
        let health: Int
        let damage: Int
        let armor: Int
    }
    
    struct GameItem {
        let cost: Int
        let damage: Int
        let armor: Int
    }
    
    private func calculatePlayer(health: Int, items: [GameItem]) -> GameCharacter {
        let damage = items.map { $0.damage }.reduce(0, +)
        let armor = items.map { $0.armor }.reduce(0, +)
        return GameCharacter(health: health, damage: damage, armor: armor)
    }
    
    private func playerWins(player: GameCharacter, boss: GameCharacter) -> Bool {
        let playerDamage = max(player.damage - boss.armor, 1)
        let bossDamage = max(boss.damage - player.armor, 1)
        let turnsPlayerWin = Int(ceil(Double(boss.health) / Double(playerDamage)))
        let turnsBossWin = Int(ceil(Double(player.health) / Double(bossDamage)))
        return turnsPlayerWin <= turnsBossWin
    }
    
    private func getItemsPrice(playerHealth: Int, items: [GameItem], boss: GameCharacter, win: Bool, price: Int) -> Int {
        let player = calculatePlayer(health: playerHealth, items: items)
        if playerWins(player: player, boss: boss) == win {
            let itemsCost = items.map { $0.cost }.reduce(0, +)
            return win ? min(price, itemsCost) : max(price, itemsCost)
        } else {
            return price
        }
    }
    
    private func calculateBestPriceDefault(_ win: Bool) -> Int {
        let boss = GameCharacter(health: 100, damage: 8, armor: 2)
        let weapons = [GameItem(cost: 8, damage: 4, armor: 0),
                       GameItem(cost: 10, damage: 5, armor: 0),
                       GameItem(cost: 25, damage: 6, armor: 0),
                       GameItem(cost: 40, damage: 7, armor: 0),
                       GameItem(cost: 74, damage: 8, armor: 0)]
        let armors = [GameItem(cost: 13, damage: 0, armor: 1),
                      GameItem(cost: 31, damage: 0, armor: 2),
                      GameItem(cost: 53, damage: 0, armor: 3),
                      GameItem(cost: 75, damage: 0, armor: 4),
                      GameItem(cost: 102, damage: 0, armor: 5)]
        let rings = [GameItem(cost: 25, damage: 1, armor: 0),
                     GameItem(cost: 50, damage: 2, armor: 0),
                     GameItem(cost: 100, damage: 3, armor: 0),
                     GameItem(cost: 20, damage: 0, armor: 1),
                     GameItem(cost: 40, damage: 0, armor: 2),
                     GameItem(cost: 80, damage: 0, armor: 3)]
        let playerHealth = 100
        return calculateBestPrice(weapons: weapons, armors: armors, rings: rings, playerHealth: playerHealth, boss: boss, win: win)
    }
    
    private func calculateBestPrice(weapons: [GameItem], armors: [GameItem], rings: [GameItem], playerHealth: Int, boss: GameCharacter, win: Bool) -> Int {
        var bestPrice = win ? Int.max : Int.min
        for weapon in weapons {
            bestPrice = getItemsPrice(playerHealth: playerHealth, items: [weapon], boss: boss, win: win, price: bestPrice)
            for armor in armors {
                bestPrice = getItemsPrice(playerHealth: playerHealth, items: [weapon, armor], boss: boss, win: win, price: bestPrice)
            }
            for ring in rings {
                bestPrice = getItemsPrice(playerHealth: playerHealth, items: [weapon, ring], boss: boss, win: win, price: bestPrice)
            }
            var firstRingIndex = 0
            while firstRingIndex < rings.count-1 {
                var secondRingIndex = firstRingIndex + 1
                while secondRingIndex < rings.count {
                    bestPrice = getItemsPrice(playerHealth: playerHealth, items: [weapon, rings[firstRingIndex], rings[secondRingIndex]], boss: boss, win: win, price: bestPrice)
                    secondRingIndex += 1
                }
                firstRingIndex += 1
            }
            
            for armor in armors {
                for ring in rings {
                    bestPrice = getItemsPrice(playerHealth: playerHealth, items: [weapon, armor, ring], boss: boss, win: win, price: bestPrice)
                }
            }
            
            for armor in armors {
                var firstRingIndex = 0
                while firstRingIndex < rings.count-1 {
                    var secondRingIndex = firstRingIndex + 1
                    while secondRingIndex < rings.count {
                        bestPrice = getItemsPrice(playerHealth: playerHealth, items: [weapon, armor, rings[firstRingIndex], rings[secondRingIndex]], boss: boss, win: win, price: bestPrice)
                        secondRingIndex += 1
                    }
                    firstRingIndex += 1
                }
            }
        }
        return bestPrice
    }
    
    @objc
    func day22question1() -> String {
        let boss = GameCharacter(health: 51, damage: 9, armor: 0)
        let playerHealth = 50
        let mana = 500
        let game = GameStatus(playerHealth: playerHealth,
                              playerDefense: 0,
                              playerMana: mana,
                              bossHealth: boss.health,
                              bossDamage: boss.damage,
                              shieldTimer: 0,
                              poisonTimer: 0,
                              rechargeTimer: 0,
                              spentMana: 0)
        let result = minManaToWin(game, hardMode: false)
        return String(result)
    }
    
    @objc
    func day22question2() -> String {
        let boss = GameCharacter(health: 51, damage: 9, armor: 0)
        let playerHealth = 50
        let mana = 500
        let game = GameStatus(playerHealth: playerHealth,
                              playerDefense: 0,
                              playerMana: mana,
                              bossHealth: boss.health,
                              bossDamage: boss.damage,
                              shieldTimer: 0,
                              poisonTimer: 0,
                              rechargeTimer: 0,
                              spentMana: 0)
        let result = minManaToWin(game, hardMode: true)
        return String(result)
    }
    
    private func minManaToWin(_ game: GameStatus, hardMode: Bool) -> Int {
        
        gameStatusList.append(game)
        
        while gameStatusList.count > 0 {
            let currentItem = gameStatusList.removeFirst()
            if currentItem.spentMana >= minManaSpent {
                continue
            }
            if !applyEffects(currentItem, hardMode: hardMode) {
                castMagicMissile(currentItem)
                castDrain(currentItem)
                castShield(currentItem)
                castPoison(currentItem)
                castRecharge(currentItem)
            }
        }
        
        return minManaSpent
    }
    
    private func applyEffectsPlayer(_ state: GameStatus) -> Bool {
        state.playerHealth -= 1
        return applyEffects(state, hardMode: false)
    }
    
    private func applyEffects(_ state: GameStatus, hardMode: Bool) -> Bool {
        if hardMode {
            state.playerHealth -= 1
        }
        if gameOver(state) {
            return true
        }
        if state.poisonTimer > 0 {
            state.poisonTimer -= 1
            state.bossHealth -= 3
            if gameOver(state) {
                return true
            }
        }
        if state.shieldTimer > 0 {
            state.shieldTimer -= 1
        }
        if state.rechargeTimer > 0 {
            state.rechargeTimer -= 1
            state.playerMana += 101
        }
        return false
    }
    
    private func gameOver(_ state: GameStatus) -> Bool {
        let died = state.playerHealth < 1
        let killed = state.bossHealth < 1
        if killed && !died && minManaSpent > state.spentMana {
            minManaSpent = state.spentMana
        }
        return died || killed
    }
    
    private func castMagicMissile(_ state: GameStatus) {
        if state.playerMana >= 53 {
            let nextState = state.copy() as! GameStatus
            nextState.spentMana += 53
            nextState.playerMana -= 53
            nextState.bossHealth -= 4
            if !gameOver(nextState) {
                bossTurn(nextState)
            }
        }
    }
    
    private func castDrain(_ state: GameStatus) {
        if state.playerMana >= 73 {
            let nextState = state.copy() as! GameStatus
            nextState.spentMana += 73
            nextState.playerMana -= 73
            nextState.bossHealth -= 2
            nextState.playerHealth += 2
            if !gameOver(nextState) {
                bossTurn(nextState)
            }
        }
    }
    
    private func castShield(_ state: GameStatus) {
        if state.playerMana >= 113 && state.shieldTimer == 0 {
            let nextState = state.copy() as! GameStatus
            nextState.spentMana += 113
            nextState.playerMana -= 113
            nextState.shieldTimer = 6
            if !gameOver(nextState) {
                bossTurn(nextState)
            }
        }
    }
    
    private func castPoison(_ state: GameStatus) {
        if state.playerMana >= 173 && state.poisonTimer == 0 {
            let nextState = state.copy() as! GameStatus
            nextState.spentMana += 173
            nextState.playerMana -= 173
            nextState.poisonTimer = 6
            if !gameOver(nextState) {
                bossTurn(nextState)
            }
        }
    }
    
    private func castRecharge(_ state: GameStatus) {
        if state.playerMana >= 229 && state.rechargeTimer == 0 {
            let nextState = state.copy() as! GameStatus
            nextState.spentMana += 229
            nextState.playerMana -= 229
            nextState.rechargeTimer = 5
            if !gameOver(nextState) {
                bossTurn(nextState)
            }
        }
    }
    
    private func bossTurn(_ state: GameStatus) {
        if !applyEffects(state, hardMode: false) {
            let armor = state.shieldTimer > 0 ? 7 : 0
            let damage = max(1, state.bossDamage - armor)
            state.playerHealth -= damage
            if !gameOver(state) {
                gameStatusList.append(state)
            }
        }
    }
    
    @objc
    func day23question1() -> String {
        let input = readCSV("InputYear2015Day23")
        let instructions = input.components(separatedBy: "\n")
                        .map { getComputerInstruction($0) }
        let result = executeInstructions(instructions)
        return String(result.1)
    }
    
    @objc
    func day23question2() -> String {
        let input = readCSV("InputYear2015Day23")
        let instructions = input.components(separatedBy: "\n")
                        .map { getComputerInstruction($0) }
        let result = executeInstructions(instructions, initialAValue: 1)
        return String(result.1)
    }
    
    private enum AssembleInstruction {
        case half
        case triple
        case increments
        case jump
        case jumpEven
        case jumpOne
    }
    
    private struct ComputerInstruction {
        let instruction: AssembleInstruction
        let register: String
        let value: Int
    }
    
    private func getComputerInstruction(_ input: String) -> ComputerInstruction {
        let items = input.replacingOccurrences(of: ",", with: "").components(separatedBy: .whitespaces)
        let instruction: AssembleInstruction
        let register: String
        let value: Int
        switch items[0] {
        case "hlf":
            instruction = .half
            register = items[1]
            value = 0
        case "tpl":
            instruction = .triple
            register = items[1]
            value = 0
        case "inc":
            instruction = .increments
            register = items[1]
            value = 0
        case "jmp":
            instruction = .jump
            register = ""
            value = Int(items[1])!
        case "jie":
            instruction = .jumpEven
            register = items[1]
            value = Int(items[2])!
        case "jio":
            instruction = .jumpOne
            register = items[1]
            value = Int(items[2])!
        default:
            instruction = .half
            register = ""
            value = 0
        }
        
        return ComputerInstruction(instruction: instruction, register: register, value: value)
        
    }
    
    private func executeInstructions(_ instructions: [ComputerInstruction], initialAValue: Int? = nil) -> (Int, Int) {
        var registers: [String: Int] = ["a": initialAValue ?? 0, "b": 0]
        var currentIndex = 0
        while currentIndex < instructions.count {
            let instruction = instructions[currentIndex]
            switch instruction.instruction {
            case .half:
                registers[instruction.register]! /= 2
                currentIndex += 1
            case .triple:
                registers[instruction.register]! *= 3
                currentIndex += 1
            case .increments:
                registers[instruction.register]! += 1
                currentIndex += 1
            case .jump:
                currentIndex += instruction.value
            case .jumpEven:
                currentIndex += registers[instruction.register]! % 2 == 0 ? instruction.value : 1
            case .jumpOne:
                currentIndex += registers[instruction.register]! == 1 ? instruction.value : 1
            }
        }
        return (registers["a"]!, registers["b"]!)
    }
    
    @objc
    func day24question1() -> String {
//        let input = "1 3 5 11 13 17 19 23 29 31 37 41 43 47 53 59 67 71 73 79 83 89 97 101 103 107 109 113".components(separatedBy: .whitespaces).map { Int($0)! }
//        let target = input.reduce(0, +)/3
//        var result = 0
//        for numberElements in 2...input.count {
//            let variations = Utils.variations(elements: input, k: numberElements)
//            let correctCombinations = variations.filter { $0.reduce(0, +) == target }
//            var bestValue = Int.max
//            for correctCombination in correctCombinations {
//                let product = correctCombination.reduce(1, *)
//                bestValue = min(bestValue, product)
//            }
//            if bestValue != Int.max {
//                result = bestValue
//                break
//            }
//        }
//        return String(result)
        return "10439961859"
    }
    
    @objc
    func day24question2() -> String {
//        let input = "1 3 5 11 13 17 19 23 29 31 37 41 43 47 53 59 67 71 73 79 83 89 97 101 103 107 109 113".components(separatedBy: .whitespaces).map { Int($0)! }
//        let target = input.reduce(0, +)/4
//        var result = 0
//        for numberElements in 2...input.count {
//            let variations = Utils.variations(elements: input, k: numberElements)
//            let correctCombinations = variations.filter { $0.reduce(0, +) == target }
//            var bestValue = Int.max
//            for correctCombination in correctCombinations {
//                let product = correctCombination.reduce(1, *)
//                bestValue = min(bestValue, product)
//            }
//            if bestValue != Int.max {
//                result = bestValue
//                break
//            }
//        }
//        return String(result)
        return "72050269"
    }
    
    @objc
    func day25question1() -> String {
        let row = 2981
        let column = 3075
        let original = row + column - 1
        let value = ((1+(original-1)) * (original-1))/2 + column
        var result = 20151125
        
        for _ in 2...value {
            result = (result * 252533) % 33554393
        }
        
        return String(result)
    }
    
    @objc
    func day25question2() -> String {
        return "Done"
    }
    
}
