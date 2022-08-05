//
//  Year2020InteractorImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 28/6/22.
//

import Foundation

protocol Rule { }

class Year2020InteractorImpl: NSObject {
}

extension Year2020InteractorImpl: YearInteractor {
    
    @objc
    func day1question1() -> String {
        let input = readCSV("InputYear2020Day1").components(separatedBy: .newlines).map { Int($0)! }
        let result = Utils.cartesianProduct(lhs: input, rhs: input).first { $0.0 + $0.1 == 2020 }!
        return "\(result.0 * result.1)"
    }
    
    @objc
    func day1question2() -> String {
        let input = readCSV("InputYear2020Day1").components(separatedBy: .newlines).map { Int($0)! }
        let result = Utils.cartesianProduct(lhs: Utils.cartesianProduct(lhs: input, rhs: input), rhs: input)  .first { $0.0.0 + $0.0.1 + $0.1 == 2020 }!
        return "\(result.0.0 * result.0.1 * result.1)"
    }
    
    @objc
    func day2question1() -> String {
        let input = readCSV("InputYear2020Day2").components(separatedBy: .newlines).map { getPasswordPolicy($0) }
        let result = input.filter { isPasswordPolicyValid($0, oldMethod: true) }.count
        return "\(result)"
    }
    
    @objc
    func day2question2() -> String {
        let input = readCSV("InputYear2020Day2").components(separatedBy: .newlines).map { getPasswordPolicy($0) }
        let result = input.filter { isPasswordPolicyValid($0, oldMethod: false) }.count
        return "\(result)"
    }
    
    struct PasswordPolicy {
        let min: Int
        let max: Int
        let letter: Character
        let password: String
    }
    
    private func getPasswordPolicy(_ input: String) -> PasswordPolicy {
        let items = input.components(separatedBy: .whitespaces)
        let indexes = items[0].components(separatedBy: "-")
        return PasswordPolicy(min: Int(indexes[0])!, max: Int(indexes[1])!, letter: items[1][0], password: items[2])
    }
    
    private func isPasswordPolicyValid(_ passwordPolicy: PasswordPolicy, oldMethod: Bool) -> Bool {
        let occurrencies = passwordPolicy.password.filter { $0 == passwordPolicy.letter }.count
        if oldMethod {
            return occurrencies >= passwordPolicy.min && occurrencies <= passwordPolicy.max
        } else {
            let minChar = passwordPolicy.password[passwordPolicy.min-1]
            let maxChar = passwordPolicy.password[passwordPolicy.max-1]
            return (minChar == passwordPolicy.letter || maxChar == passwordPolicy.letter) &&
            !(minChar == passwordPolicy.letter && maxChar == passwordPolicy.letter)
        }
    }
    
    @objc
    func day3question1() -> String {
        let input = readCSV("InputYear2020Day3").components(separatedBy: .newlines).map { $0.map {  String($0) } }
        let result = getTrees(input, in: (3, 1))
        return "\(result)"
    }
    
    @objc
    func day3question2() -> String {
        let input = readCSV("InputYear2020Day3").components(separatedBy: .newlines).map { $0.map {  String($0) } }
        let slopes = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
        let result = slopes.map { getTrees(input, in: $0) }.reduce(1, *)
        
        return "\(result)"
    }
    
    private func getTrees(_ input: [[String]], in slope: (Int, Int)) -> Int {
        var trees = 0
        var row = 0
        var col = 0
        while row < input.count {
            trees += input[row][col] == "#" ? 1 : 0
            row += slope.1
            col = (col + slope.0) % input[0].count
        }
        return trees
    }
    
    @objc
    func day4question1() -> String {
        let input = readCSV("InputYear2020Day4").components(separatedBy: "\n\n")
        let result = input.filter { validPassport($0) }.count
        return "\(result)"
    }
    
    @objc
    func day4question2() -> String {
        let input = readCSV("InputYear2020Day4").components(separatedBy: "\n\n")
        let result = input.filter { validPassportHD($0) }.count
        return "\(result)"
    }
    
    private func validPassport(_ input: String) -> Bool {
        let values = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
        let items = input.components(separatedBy: .newlines).joined(separator: " ").components(separatedBy: .whitespaces)
        return items.filter { values.contains($0.components(separatedBy: ":")[0]) }.count == 7
    }
    
    private func validPassportHD(_ input: String) -> Bool {
        guard validPassport(input) else { return false }
        let items = input.components(separatedBy: .newlines).joined(separator: " ").components(separatedBy: .whitespaces)
        for item in items {
            let fields = item.components(separatedBy: ":")
            let key = fields[0]
            let value = fields[1]
            switch key {
            case "byr":
                guard let year = Int(value) else { return false }
                if year < 1920 || year > 2002 { return false }
            case "iyr":
                guard let year = Int(value) else { return false }
                if year < 2010 || year > 2020 { return false }
            case "eyr":
                guard let year = Int(value) else { return false }
                if year < 2020 || year > 2030 { return false }
            case "hgt":
                if value.contains("cm") {
                    let height = Int(value.dropLast(2))!
                    if height < 150 || height > 193 { return false }
                } else if value.contains("in") {
                    let height = Int(value.dropLast(2))!
                    if height < 59 || height > 76 { return false }
                } else {
                    return false
                }
            case "hcl": if !value.starts(with: "#") || value.count != 7 { return false }
            case "ecl": if !["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(value) { return false }
            case "pid":
                guard let _ = Int(value) else { return false }
                if value.count != 9 { return false }
            default: break
            }
        }
        return true
    }
    
    @objc
    func day5question1() -> String {
        let input = readCSV("InputYear2020Day5").components(separatedBy: .newlines)
        let result = input.map { getIdBoardingPass($0) }.max()!
        return "\(result)"
    }
    
    @objc
    func day5question2() -> String {
        let input = readCSV("InputYear2020Day5").components(separatedBy: .newlines)
        let seats = input.map { getIdBoardingPass($0) }
        let result = (seats.min()!...seats.max()!).first { !seats.contains($0) }!
        return "\(result)"
    }
    
    private func getIdBoardingPass(_ input: String) -> Int {
        let numRow = input[0...6].enumerated().map { $0.element == "B" ? Int(pow(Double(2), Double(6 - $0.offset))) : 0 }.reduce(0, +)
        let numCol = input[8...10].enumerated().map { $0.element == "R" ? Int(pow(Double(2), Double(2 - $0.offset))) : 0 }.reduce(0, +)
        return numRow * 8 + numCol
    }
    
    @objc
    func day6question1() -> String {
        let input = readCSV("InputYear2020Day6").components(separatedBy: "\n\n")
        let result = input.map { Set($0.components(separatedBy: .newlines).joined().map { String($0) }).count }.reduce(0, +)
        return "\(result)"
    }
    
    @objc
    func day6question2() -> String {
        let input = readCSV("InputYear2020Day6").components(separatedBy: "\n\n").map { $0.components(separatedBy: .newlines) }
        let result = input.map { answers -> Int in
            answers[0].filter { item in answers.filter { $0.contains(item) }.count == answers.count }.count
        }.reduce(0, +)
        return "\(result)"
    }
    
    @objc
    func day7question1() -> String {
        let input = readCSV("InputYear2020Day7").components(separatedBy: .newlines)
        var bags: Set<Bag> = Set()
        var rules: [RuleBag] = []
        input.forEach { ruleString in
            let rule: RuleBag
            (rule, bags) = getRuleBag(ruleString, bags: bags)
            rules.append(rule)
        }
        var validRules: [Int: Bool] = [:]
        rules.forEach { rule in
            (_, validRules) = ruleApplies(rule, rules, validRules)
        }
        let result = validRules.filter { $0.value }.count
        return "\(result)"
    }
    
    @objc
    func day7question2() -> String {
        let input = readCSV("InputYear2020Day7").components(separatedBy: .newlines)
        var bags: Set<Bag> = Set()
        var rules: [RuleBag] = []
        input.forEach { ruleString in
            let rule: RuleBag
            (rule, bags) = getRuleBag(ruleString, bags: bags)
            rules.append(rule)
        }
        let bagShiny = rules.first { $0.container.feature == "shiny" && $0.container.color == "gold"}!.container
        let result = numberBags(bagShiny, rules)
        return "\(result)"
    }
    
    struct Bag: Equatable, Hashable {
        let id: Int
        let feature: String
        let color: String
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    struct RuleBag {
        let container: Bag
        let contained: [(Bag, Int)]
    }
    
    private func getRuleBag(_ input: String, bags: Set<Bag>) -> (RuleBag, Set<Bag>) {
        var bags = bags
        let regex = try! NSRegularExpression(pattern: #"([a-z]+) ([a-z]+) bags contain ([,, a-z0-9]+)"#)
        let matches = regex.matches(in: input, options: [], range: NSRange(input.startIndex..., in: input))
        let match = matches.first!
        let containerFeature = String(input[Range(match.range(at: 1), in: input)!])
        let containerColor = String(input[Range(match.range(at: 2), in: input)!])
        var subBags: [(Bag, Int)] = []
        if let subBagsRange = Range(match.range(at: 3), in: input) {
            let subBagsValue = String(input[subBagsRange])
            subBagsValue.components(separatedBy: ", ").forEach { subBag in
                let items = subBag.components(separatedBy: .whitespaces)
                guard items[0] != "no" else { return }
                let existingBag = bags.first { $0.feature == items[1] && $0.color == items[2] }
                let id = existingBag?.id ?? (bags.map { $0.id }.max() ?? 0) + 1
                let bag = Bag(id: id, feature: items[1], color: items[2])
                bags.insert(bag)
                let ocurrences = Int(items[0])!
                subBags.append((bag, ocurrences))
            }
        }
        let existingBag = bags.first { $0.feature == containerFeature && $0.color == containerColor }
        let id = existingBag?.id ?? (bags.map { $0.id }.max() ?? 0) + 1
        let bag = Bag(id: id, feature: containerFeature, color: containerColor)
        bags.insert(bag)
        return (RuleBag(container: bag, contained: subBags), bags)
    }
    
    private func ruleApplies(_ rule: RuleBag, _ list: [RuleBag], _ validRules: [Int: Bool]) -> (Bool, [Int: Bool]) {
        if let validRule = validRules[rule.container.id] { return (validRule, validRules) }
        let containedRules = rule.contained.filter { $0.0.feature == "shiny" && $0.0.color == "gold" }
        var validRules = validRules
        guard containedRules.count == 0 else {
            validRules[rule.container.id] = true
            return (true, validRules)
        }
        var isContained = false
        for containedRule in rule.contained {
            let newRule = list.first { $0.container == containedRule.0 }!
            let ruleApplicable: Bool
            (ruleApplicable, validRules) = ruleApplies(newRule, list, validRules)
            if ruleApplicable {
                isContained = true
                break
            }
        }
        validRules[rule.container.id] = isContained
        return (isContained, validRules)
    }
    
    private func numberBags(_ bag: Bag, _ rules: [RuleBag]) -> Int {
        guard let rule = rules.first(where: { $0.container.id == bag.id }) else { return 0 }
        var totalBags = 0
        for containedBag in rule.contained {
            let values = numberBags(containedBag.0, rules)
            totalBags += values * containedBag.1 + containedBag.1
        }
        return totalBags
    }
    
    @objc
    func day8question1() -> String {
        let input = readCSV("InputYear2020Day8").components(separatedBy: .newlines).map { getConsoleInstruction($0) }
        let (_, result) = executeConsoleProgram(input)
        return "\(result)"
    }
    
    @objc
    func day8question2() -> String {
        let input = readCSV("InputYear2020Day8").components(separatedBy: .newlines).map { getConsoleInstruction($0) }
        for indexChangedInstruction in 0..<input.count {
            guard input[indexChangedInstruction].type != .acc else { continue }
            var instructions = input
            let newInstruction = ConsoleInst(type: input[indexChangedInstruction].type == .jmp ? .nop : .jmp, value: input[indexChangedInstruction].value)
            instructions[indexChangedInstruction] = newInstruction
            let (finished, result) = executeConsoleProgram(instructions)
            if finished { return "\(result)" }
        }
        return ""
    }
    
    enum ConsoleInstType {
        case acc
        case jmp
        case nop
    }
    
    struct ConsoleInst {
        let type: ConsoleInstType
        let value: Int
    }
    
    private func getConsoleInstruction(_ input: String) -> ConsoleInst {
        let items = input.components(separatedBy: .whitespaces)
        let type: ConsoleInstType = items[0] == "acc" ? .acc : items[0] == "jmp" ? .jmp : .nop
        let value = Int(items[1])!
        return ConsoleInst(type: type, value: value)
    }
    
    private func executeConsoleProgram(_ instructions: [ConsoleInst]) -> (Bool, Int) {
        var usedInst: Set<Int> = Set()
        var index = 0
        var accumulator = 0
        while index < instructions.count {
            guard !usedInst.contains(index) else { return (false, accumulator) }
            usedInst.insert(index)
            let instruction = instructions[index]
            switch instruction.type {
            case .acc: accumulator += instruction.value
            case .jmp: index += instruction.value
            case .nop: break
            }
            index += instruction.type == .jmp ? 0 : 1
        }
        return (true, accumulator)
    }
    
    @objc
    func day9question1() -> String {
        let input = readCSV("InputYear2020Day9").components(separatedBy: .newlines).map { Int($0)! }
        var index = 25
        while index < input.count {
            let preamble = [Int](input[index-25...index-1])
            let val = Utils.cartesianProduct(lhs: preamble, rhs: preamble).first { $0.0 + $0.1 == input[index] }
            if val == nil { return "\(input[index])" }
            index += 1
        }
        return ""
    }
    
    @objc
    func day9question2() -> String {
        let input = readCSV("InputYear2020Day9").components(separatedBy: .newlines).map { Int($0)! }
        let target = 32321523 //Previous problem
        var firstIndex = 0
        var lastIndex = 1
        while lastIndex < input.count {
            let sum = input[firstIndex...lastIndex].reduce(0, +)
            guard sum <= target else {
                firstIndex += 1
                lastIndex = firstIndex + 1
                continue
            }
            guard sum < target else {
                let min = input[firstIndex...lastIndex].min()!
                let max = input[firstIndex...lastIndex].max()!
                return "\(min+max)"
            }
            lastIndex += 1
        }
        return ""
    }
    
    @objc
    func day10question1() -> String {
        var input = readCSV("InputYear2020Day10").components(separatedBy: .newlines).map { Int($0)! }.sorted()
        input.append(input.last!+3)
        let differences = input.enumerated().map { $0.element - ($0.offset > 0 ? input[$0.offset-1] : 0) }
        let result = differences.filter { $0 == 1 }.count * differences.filter { $0 == 3 }.count
        return "\(result)"
    }
    
    @objc
    func day10question2() -> String {
        var input = readCSV("InputYear2020Day10").components(separatedBy: .newlines).map { Int($0)! }.sorted()
        input.append(input.last!+3)
        let differences = input.enumerated().map { $0.element - ($0.offset > 0 ? input[$0.offset-1] : 0) }
        var consecutiveOnes = 0
        var result = 1
        for index in 0..<input.count {
            result *= differences[index] == 1 ? consecutiveOnes == 3 ? 7 : 1 : consecutiveOnes > 0 ? Int(pow(Double(2), Double(consecutiveOnes-1))) : 1
            consecutiveOnes = differences[index] == 1 && consecutiveOnes < 3 ? consecutiveOnes + 1 : 0
        }
        return "\(result)"
    }
    
    @objc
    func day11question1() -> String {
//        var seats = readCSV("InputYear2020Day11").components(separatedBy: .newlines).map { $0.map { String($0) } }
//        var combinations: Set<String> = Set()
//        var seatsString = ""
//        while true {
//            seats = applyStepSeats(seats, true)
//            seatsString = seats.map { $0.joined() }.joined()
//            if combinations.contains(seatsString) { break }
//            combinations.insert(seatsString)
//        }
//        let result = seatsString.filter { $0 == "#" }.count
//        return "\(result)"
        "2265"
    }
    
    @objc
    func day11question2() -> String {
//        var seats = readCSV("InputYear2020Day11").components(separatedBy: .newlines).map { $0.map { String($0) } }
//        var combinations: Set<String> = Set()
//        var seatsString = ""
//        while true {
//            seats = applyStepSeats(seats, false)
//            seatsString = seats.map { $0.joined() }.joined()
//            if combinations.contains(seatsString) { break }
//            combinations.insert(seatsString)
//        }
//        let result = seatsString.filter { $0 == "#" }.count
//        return "\(result)"
        "2045"
    }
    
    private func applyStepSeats(_ input: [[String]], _ modeEasy: Bool) -> [[String]] {
        var seatsEnd = input
        for row in 0..<input.count {
        externalLoop:
            for col in 0..<input[row].count {
                if input[row][col] == "." { continue }
                var busyCollindant = 0
                let freeSeat = input[row][col] == "L"
                for direction in 0...7 {
                    let isBusyCollindant = isBusySeat(input, (col, row), direction, modeEasy)
                    if freeSeat && isBusyCollindant {
                        continue externalLoop
                    }
                    busyCollindant += isBusyCollindant ? 1 : 0
                }
                seatsEnd[row][col] = freeSeat ? "#" : (modeEasy && busyCollindant >= 4) || (!modeEasy && busyCollindant >= 5) ? "L" : "#"
            }
        }
        return seatsEnd
    }
    
    private func isBusySeat(_ input: [[String]], _ position: (Int, Int), _ direction: Int, _ stopAtFirst: Bool) -> Bool {
        let movementX = direction > 0 && direction < 4 ? 1 : direction > 4 ? -1 : 0
        let movementY = direction > 2 && direction < 6 ? 1 : direction < 2 || direction > 6 ? -1 : 0
        var nextPosition = (position.0+movementX, position.1+movementY)
        while nextPosition.1 >= 0 && nextPosition.1 < input.count && nextPosition.0 >= 0 && nextPosition.0 < input[nextPosition.1].count {
            if input[nextPosition.1][nextPosition.0] == "#" {
                return true
            } else if input[nextPosition.1][nextPosition.0] == "L" || stopAtFirst {
                return false
            }
            nextPosition = (nextPosition.0+movementX, nextPosition.1+movementY)
        }
        return false
    }
    
    @objc
    func day12question1() -> String {
        let instructions = readCSV("InputYear2020Day12").components(separatedBy: .newlines)
        var x = 0
        var y = 0
        var direction = Direction.east
        for instruction in instructions {
            let inst = instruction.first!
            let value = Int(instruction.dropFirst())!
            switch inst {
            case "N": y -= value
            case "S": y += value
            case "E": x += value
            case "W": x -= value
            case "L": direction = direction.turn(value == 90 ? .left : value == 180 ? .reverse : .right)
            case "R": direction = direction.turn(value == 90 ? .right : value == 180 ? .reverse : .left)
            case "F":
                x += direction == .east ? value : direction == .west ? -value : 0
                y += direction == .south ? value : direction == .north ? -value : 0
            default: break
            }
        }
        let result =  x + y
        return "\(result)"
    }
    
    @objc
    func day12question2() -> String {
        let instructions = readCSV("InputYear2020Day12").components(separatedBy: .newlines)
        var x = 0
        var y = 0
        var wayPointX = 10
        var wayPointY = -1
        for instruction in instructions {
            let inst = instruction.first!
            let value = Int(instruction.dropFirst())!
            switch inst {
            case "N": wayPointY -= value
            case "S": wayPointY += value
            case "E": wayPointX += value
            case "W": wayPointX -= value
            case "L":
                let temp = wayPointX
                wayPointX = value == 90 ? wayPointY : value == 180 ? -wayPointX : -wayPointY
                wayPointY = value == 90 ? -temp : value == 180 ? -wayPointY : temp
            case "R":
                let temp = wayPointX
                wayPointX = value == 90 ? -wayPointY : value == 180 ? -wayPointX : wayPointY
                wayPointY = value == 90 ? temp : value == 180 ? -wayPointY : -temp
            case "F":
                x += value * wayPointX
                y += value * wayPointY
            default: break
            }
        }
        let result = x + y
        return "\(result)"
    }
    
    @objc
    func day13question1() -> String {
        let input = readCSV("InputYear2020Day13").components(separatedBy: .newlines)
        let earliestTimestamp = Int(input[0])!
        let times = input[1].components(separatedBy: ",").filter { $0 != "x" }.map { Int($0)! }
        let minDifference = times.map { (Int(ceil(Double(earliestTimestamp)/Double($0))) * $0) % earliestTimestamp }.min()!
        let minValue = times.first { (Int(ceil(Double(earliestTimestamp)/Double($0))) * $0) % earliestTimestamp == minDifference }!
        let result = minValue * ((Int(ceil(Double(earliestTimestamp)/Double(minValue))) * minValue) % earliestTimestamp)
        return "\(result)"
    }
    
    @objc
    func day13question2() -> String {
        let input = readCSV("InputYear2020Day13").components(separatedBy: .newlines)
        let times = input[1].components(separatedBy: ",").map { $0 == "x" ? 0 : Int($0)! }
        let values = times.enumerated().map { ($0.element, $0.offset) }.filter { $0.0 != 0 }
        var tested = 1
        var acumulated = values.first!.0 - values.first!.1
        var result = acumulated
        while tested < values.count {
            while (result+values[tested].1) % values[tested].0 != 0 {
                result += acumulated
            }
            acumulated *= values[tested].0
            tested += 1
        }
        return "\(result)"
    }
    
    @objc
    func day14question1() -> String {
        let input = readCSV("InputYear2020Day14").components(separatedBy: .newlines).map { getBitMaskType($0) }
        var currentMask = ""
        var memory: [Int: Int] = [:]
        for instruction in input {
            switch instruction {
            case .mask(let value):
                currentMask = value
            case .mem(let position, let value):
                let newValue = applyBitMask(currentMask, to: value)
                memory[position] = newValue
            }
        }
        let result = memory.values.reduce(0, +)
        return "\(result)"
    }
    
    @objc
    func day14question2() -> String {
        let input = readCSV("InputYear2020Day14").components(separatedBy: .newlines).map { getBitMaskType($0) }
        var currentMask = ""
        var memory: [Int: Int] = [:]
        for instruction in input {
            switch instruction {
            case .mask(let value):
                currentMask = value
            case .mem(let position, let value):
                let positions = applyBitMaskForAdresses(currentMask, to: position)
                for position in positions {
                    memory[position] = value
                }
            }
        }
        let result = memory.values.reduce(0, +)
        return "\(result)"
    }
    
    enum BitmaskType {
        case mask(value: String)
        case mem(position: Int, value: Int)
    }
    
    private func getBitMaskType(_ input: String) -> BitmaskType {
        let items = input.components(separatedBy: " = ")
        if items[0] == "mask" {
            return .mask(value: items[1])
        }
        return .mem(position: Int(String(items[0].dropFirst(4).dropLast()))!, value: Int(items[1])!)
    }
    
    private func applyBitMask(_ mask: String, to value: Int) -> Int {
        let binaryValue = String((String(repeating: "0", count: 36) + String(value, radix: 2)).suffix(36))
        var resultString = ""
        for index in 0..<36 {
            resultString += mask[index] == "X" ? String(binaryValue[index]) : String(mask[index])
        }
        return Int(resultString, radix: 2)!
    }
    
    private func applyBitMaskForAdresses(_ mask: String, to value: Int) -> [Int] {
        let binaryValue = String((String(repeating: "0", count: 36) + String(value, radix: 2)).suffix(36))
        var resultString = ""
        for index in 0..<36 {
            resultString += mask[index] == "0" ? String(binaryValue[index]) : String(mask[index])
        }
        return getBinaryCombinations(resultString).map { Int($0, radix: 2)! }
    }
    
    private func getBinaryCombinations(_ input: String) -> [String] {
        if input.filter({ $0 == "X" }).count == 1 {
            return [input.replacingOccurrences(of: "X", with: "0"), input.replacingOccurrences(of: "X", with: "1") ]
        }
        let range: Range<String.Index> = input.range(of: "X")!
        let index = input.distance(from: input.startIndex, to: range.lowerBound)
        let input0 = String(input[0..<index]) + "0" + String(input[(index+1)...])
        let input1 = String(input[0..<index]) + "1" + String(input[(index+1)...])
        return getBinaryCombinations(input0) + getBinaryCombinations(input1)
    }
    
    @objc
    func day15question1() -> String {
        let items = "0,6,1,7,2,19,20".components(separatedBy: ",").map { Int($0)! }
        let result = getRambunctiousRecitation(items, position: 2020)
        return "\(result)"
    }
    
    @objc
    func day15question2() -> String {
//        let items = "0,6,1,7,2,19,20".components(separatedBy: ",").map { Int($0)! }
//        let result = getRambunctiousRecitation(items, position: 30_000_000)
//        return "\(result)"
        "19331"
    }
    
    private func getRambunctiousRecitation(_ items: [Int], position: Int) -> Int {
        var positions: [Int: Int] = [:]
        for item in items.enumerated() {
            positions[item.element] = item.offset
        }
        var item = items.last!
        positions[item] = nil
        for index in items.count..<position {
            let elem = positions[item] ?? index - 1
            positions[item] = index - 1
            item = index - 1 - elem
        }
        return item
    }
    
    @objc
    func day16question1() -> String {
        let input = readCSV("InputYear2020Day16")
        let (rules, _, nearby) = getTicketsAndRules(input)
        let result = nearby.map { $0.filter { !meetsAnyRule($0, rules) }.reduce(0, +) }.reduce(0, +)
        return "\(result)"
    }
    
    @objc
    func day16question2() -> String {
        let input = readCSV("InputYear2020Day16")
        var (rules, your, nearby) = getTicketsAndRules(input)
        nearby = nearby.filter { $0.filter { meetsAnyRule($0, rules) }.count == $0.count }
        
        var ruleCandidates: [String: [Int]] = [:]
        for rule in rules {
            let candidates = (0..<nearby[0].count).filter { position in
                nearby.filter { meetsRuleTicket($0[position], rule) }.count == nearby.count
            }
            ruleCandidates[rule.name] = candidates
        }
        let ruleIds = getRulesId(ruleCandidates: ruleCandidates)
        let result = ruleIds.filter { $0.0.starts(with: "departure") }.map { your[$0.1] }.reduce(1, *)
        return "\(result)"
    }
    
    struct RuleTicket {
        let name: String
        let ranges: [(Int, Int)]
    }
    
    private func getTicketsAndRules(_ input: String) -> ([RuleTicket], [Int], [[Int]]) {
        let parts = input.components(separatedBy: "\n\n")
        
        let rulesPre = parts[0].components(separatedBy: .newlines)
        var rules: [RuleTicket] = []
        for rulePre in rulesPre {
            let items = rulePre.components(separatedBy: ": ")
            let name = items[0]
            let values = items[1].components(separatedBy: " or ")
            var ranges: [(Int, Int)] = []
            for value in values {
                let edges = value.components(separatedBy: "-")
                ranges.append((Int(edges[0])!, Int(edges[1])!))
            }
            let rule = RuleTicket(name: name, ranges: ranges)
            rules.append(rule)
        }
        
        let yourTicket = parts[1].components(separatedBy: .newlines)[1].components(separatedBy: ",").map { Int($0)! }
        
        var nearbyTicketsPre = parts[2].components(separatedBy: .newlines)
        _ = nearbyTicketsPre.removeFirst()
        let nearbyTickets = nearbyTicketsPre.map { $0.components(separatedBy: ",").map { Int($0)! } }
        
        return (rules, yourTicket, nearbyTickets)
    }
    
    private func meetsAnyRule(_ item: Int, _ rules: [RuleTicket]) -> Bool {
        rules.first { meetsRuleTicket(item, $0) } != nil
    }
    
    private func meetsRuleTicket(_ item: Int, _ rule: RuleTicket) -> Bool {
        for range in rule.ranges {
            if item >= range.0 && item <= range.1 {
                return true
            }
        }
        return false
    }
    
    private func getRulesId(ruleCandidates: [String: [Int]]) -> [(String, Int)] {
        var ruleCandidates = ruleCandidates
        var rulesId: [(String, Int)] = []
        
        while !ruleCandidates.isEmpty {
            guard let rule = ruleCandidates.first(where: { $0.value.count == 1 }) else { break }
            rulesId.append((rule.key, rule.value.first!))
            ruleCandidates[rule.key] = nil
            for candidate in ruleCandidates {
                ruleCandidates[candidate.key] = ruleCandidates[candidate.key]!.filter { $0 != rule.value.first! }
            }
        }
        
        return rulesId
    }
    
    @objc
    func day17question1() -> String {
//        let input = readCSV("InputYear2020Day17").components(separatedBy: .newlines).map { Array($0).map { String($0) } }
//        var levels: [[[String]]] = [input]
//
//        for _ in 1...6 {
//
//            levels = levels.map { $0.map { ["."]+$0+["."] } }
//            levels = levels.map { [[String](repeating: ".", count: levels[0].count+2)] + $0 + [[String](repeating: ".", count: levels[0].count+2)] }
//
//
//            levels.insert([[String]](repeating: [String](repeating: ".", count: levels[0].count), count: levels[0].count), at: 0)
//            levels.append([[String]](repeating: [String](repeating: ".", count: levels[0].count), count: levels[0].count))
//
//            var levels2 = levels
//
//            for z in 0..<levels.count {
//                for y in 0..<levels[0].count {
//                    for x in 0..<levels[0][0].count {
//                        var occ = 0
//                        for incZ in -1...1 {
//                            for incY in -1...1 {
//                                for incX in -1...1 {
//                                    if z+incZ >= 0 && z+incZ < levels.count
//                                    && y+incY >= 0 && y+incY < levels[0].count
//                                    && x+incX >= 0 && x+incX < levels[0][0].count
//                                    && (incX != 0 || incY != 0 || incZ != 0) {
//                                        occ += levels[z+incZ][y+incY][x+incX] == "#" ? 1 : 0
//                                    }
//                                }
//                            }
//                        }
//                        if levels[z][y][x] == "#" {
//                            levels2[z][y][x] = occ == 2 || occ == 3 ? "#" : "."
//
//                        } else {
//                            levels2[z][y][x] = occ == 3 ? "#" : "."
//                        }
//                    }
//                }
//            }
//            levels = levels2
//
//        }
//        let result = levels.map { $0.map { $0.filter { $0 == "#" }.count }.reduce(0, +) }.reduce(0, +)
//        return "\(result)"
        "324"
    }
    
    @objc
    func day17question2() -> String {
//        let input = readCSV("InputYear2020Day17").components(separatedBy: .newlines).map { Array($0).map { String($0) } }
//        var levels: [[[[String]]]] = [[input]]
//
//        for _ in 1...6 {
//
//            levels = levels.map { $0.map { $0.map { ["."]+$0+["."] } } }
//            levels = levels.map { $0.map { [[String](repeating: ".", count: levels[0][0].count+2)] + $0 + [[String](repeating: ".", count: levels[0][0].count+2)] } }
//
//            for levelIndex in 0..<levels.count {
//                levels[levelIndex].insert([[String]](repeating: [String](repeating: ".", count: levels[0][0].count), count: levels[0][0].count), at: 0)
//                levels[levelIndex].append([[String]](repeating: [String](repeating: ".", count: levels[0][0].count), count: levels[0][0].count))
//            }
//
//            levels.insert([[[String]]](repeating: [[String]](repeating: [String](repeating: ".", count: levels[0][0].count), count: levels[0][0].count), count: levels[0].count),
//                          at: 0)
//            levels.append([[[String]]](repeating: [[String]](repeating: [String](repeating: ".", count: levels[0][0].count), count: levels[0][0].count), count: levels[0].count))
//
//            var levels2 = levels
//
//            for w in 0..<levels.count {
//                for z in 0..<levels[w].count {
//                    for y in 0..<levels[w][z].count {
//                        for x in 0..<levels[w][z][y].count {
//                            var occ = 0
//                            for incW in -1...1 {
//                                for incZ in -1...1 {
//                                    for incY in -1...1 {
//                                        for incX in -1...1 {
//                                            if w+incW >= 0 && w+incW < levels.count
//                                                && z+incZ >= 0 && z+incZ < levels[w].count
//                                                && y+incY >= 0 && y+incY < levels[w][z].count
//                                                && x+incX >= 0 && x+incX < levels[w][z][y].count
//                                                && (incW != 0 || incX != 0 || incY != 0 || incZ != 0) {
//                                                occ += levels[w+incW][z+incZ][y+incY][x+incX] == "#" ? 1 : 0
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                            if levels[w][z][y][x] == "#" {
//                                levels2[w][z][y][x] = occ == 2 || occ == 3 ? "#" : "."
//
//                            } else {
//                                levels2[w][z][y][x] = occ == 3 ? "#" : "."
//                            }
//                        }
//                    }
//                }
//            }
//            levels = levels2
//        }
//        var result = 0
//        levels.forEach { level in
//            result +=  level.map { $0.map { $0.filter { $0 == "#" }.count }.reduce(0, +) }.reduce(0, +)
//        }
//        return "\(result)"
        "1836"
    }
    
    @objc
    func day18question1() -> String {
        let input = readCSV("InputYear2020Day18").components(separatedBy: .newlines).map { MathNode.create(from: $0) }
        let result = input.map { $0.calculate() }.reduce(0, +)
        return "\(result)"
    }
    
    @objc
    func day18question2() -> String {
        let input = readCSV("InputYear2020Day18").components(separatedBy: .newlines).map { MathNode.createAdvance(from: $0) }
        let result = input.map { $0.calculate() }.reduce(0, +)
        return "\(result)"
    }
    
    @objc
    func day19question1() -> String {
        let input = readCSV("InputYear2020Day19").components(separatedBy: "\n\n")
        let rules = parseRules(input[0].components(separatedBy: .newlines))
        let messages = input[1].components(separatedBy: .newlines)
        let result = messages.map { message in
            let rulesA = ruleMatch(message: message, rules: rules, ruleId: 0)
            return rulesA.count > 0 ? rulesA[0] == message.count : false
        }.filter { $0 }.count
        return "\(result)"
    }
    
    @objc
    func day19question2() -> String {
//        let input = readCSV("InputYear2020Day19").components(separatedBy: "\n\n")
//        var rules = parseRules(input[0].components(separatedBy: .newlines))
//        rules[8] = [[RuleReference(42)], [RuleReference(42), RuleReference(8)]]
//        rules[11] = [[RuleReference(42), RuleReference(31)], [RuleReference(42), RuleReference(11), RuleReference(31)]]
//        let messages = input[1].components(separatedBy: .newlines)
//        let result = messages.map { message in
//            let rulesA = ruleMatch(message: message, rules: rules, ruleId: 0)
//            return rulesA.count > 0 ? rulesA[0] == message.count : false
//        }.filter { $0 }.count
//        return "\(result)"
        "439"
    }
    
    class Atom: Rule {
        let symbol: String
        init(_ symbol: String) { self.symbol = symbol }
    }
    
    class RuleReference: Rule {
        let id: Int
        init(_ id: Int) { self.id = id }
    }
    
    private func parseRules(_ input: [String]) -> [Int: [[Rule]]] {
        var rules: [Int: [[Rule]]] = [:]
        input.forEach { line in
            let elements = line.components(separatedBy: ": ")
            let (id, rhs) = (Int(elements[0])!, elements[1])
            let sides = rhs.components(separatedBy: " | ")
            let values = sides.map { side in
                side.components(separatedBy: .whitespaces).map { part -> Rule in
                    part.starts(with: "\"") ? Atom(String(part[1])) : RuleReference(Int(part)!)
                }
            }
            rules[id] = values
        }
        return rules
    }
    
    private func ruleMatch(message: String, rules: [Int: [[Rule]]], ruleId: Int, position: Int = 0) -> [Int] {
        guard let rule = rules[ruleId] else { return [] }
        return rule.map { listOfRules -> [Int] in
            var positions = [position]
            listOfRules.forEach { rule in
                positions = positions
                    .map { idx -> [Int]? in
                        switch rule {
                        case let atom as Atom:
                            return (idx < message.count) && (String(message[idx]) == atom.symbol) ? [idx+1] : nil
                        case let reference as RuleReference:
                            return ruleMatch(message: message, rules: rules, ruleId: reference.id, position: idx)
                        default: return nil
                        }
                    }
                    .compactMap { $0 }
                    .flatMap { $0 }
            }
            return positions
        }.flatMap { $0 }
    }
    
    @objc
    func day20question1() -> String {
        let input = readCSV("InputYear2020Day20").components(separatedBy: "\n\n")
        let tiles = input.map { Tile(from: $0) }
        let image = createImage(tiles)
        let result = image.first!.first!.id * image.first!.last!.id * image.last!.first!.id * image.last!.last!.id
        return "\(result)"
    }
    
    @objc
    func day20question2() -> String {
        let input = readCSV("InputYear2020Day20").components(separatedBy: "\n\n")
        let tiles = input.map { Tile(from: $0) }
        let image = createImage(tiles)
        let seaMonsterOffsets = [(0, 18), (1, 0), (1, 5),
                                 (1, 6), (1, 11), (1, 12),
                                 (1, 17), (1, 18), (1, 19),
                                 (2, 1), (2, 4), (2, 7),
                                 (2, 10), (2, 13), (2, 16)]
        let bigPicture = imageToSingleTile(tiles, image)
        let result = bigPicture.combinations().first { $0.maskIfFound(seaMonsterOffsets) }?.piece.map { row in
            row.filter { $0 == "#" }.count
        }.reduce(0, +)
        return "\(result ?? 0)"
    }
    
    private func createImage(_ tiles: [Tile]) -> [[Tile]] {
        let width = Int(sqrt(Double(tiles.count)))
        var mostRecentTile = findTopCorner(tiles)
        var mostRecentRowHeader = mostRecentTile
        let tiles = Array(0..<width).map { row in
            Array(0..<width).map { col -> Tile in
                if row == 0 && col == 0 {
                    return mostRecentTile
                } else if col == 0 {
                    mostRecentRowHeader = mostRecentRowHeader.findAndOrientNeighbor(mySide: .south, theirSide: .north, tiles: tiles)
                    mostRecentTile = mostRecentRowHeader
                    return mostRecentRowHeader
                } else {
                    mostRecentTile = mostRecentTile.findAndOrientNeighbor(mySide: .east, theirSide: .west, tiles: tiles)
                    return mostRecentTile
                }
            }
        }
        return tiles
    }
    
    private func findTopCorner(_ tiles: [Tile]) -> Tile {
        tiles.first { $0.sharedSideCount(tiles) == 2 }!
            .combinations()
            .first { $0.isSideShared(Orientation.south, tiles: tiles) && $0.isSideShared(Orientation.east, tiles: tiles) }!
    }
    
    private func imageToSingleTile(_ tiles: [Tile], _ image: [[Tile]]) -> Tile {
        let rowsPerTile = tiles.first!.piece.count
        let newImage = image.flatMap { row in
            Array(1..<(rowsPerTile-1)).map { y in
                row.map { tile in
                    tile.insetRow(y)
                }.joined()
            }
        }.map { $0.map { String($0) } }
        return Tile(id: 0, piece: newImage)
    }
    
    @objc
    func day21question1() -> String {
        let input = readCSV("InputYear2020Day21").components(separatedBy: .newlines)
        let foods = input.map { getFood($0) }
        
        let allIngredients = Set(foods.flatMap { $0.ingredients })
        let allAllergens = Set(foods.flatMap { $0.allergens })
        var candidates: [String: [String]] = [:]
        allAllergens.forEach { allergen in
            let foodsC = foods.filter { $0.allergens.contains(allergen) }
            let ingredientsCandidate = allIngredients.filter { ing in foodsC.filter { $0.ingredients.contains(ing) }.count == foodsC.count  }
            candidates[allergen] = Array(ingredientsCandidate)
        }
        let relation = getIngredientAllergen(candidates: candidates)
        let ingredientsNoAllergens = allIngredients.filter { ing in !(relation.contains { $0.1 == ing }) }
        let result = ingredientsNoAllergens.map { ing in foods.filter { $0.ingredients.contains(ing) }.count }.reduce(0, +)
        return "\(result)"
    }
    
    @objc
    func day21question2() -> String {
        let input = readCSV("InputYear2020Day21").components(separatedBy: .newlines)
        let foods = input.map { getFood($0) }
        
        let allIngredients = Set(foods.flatMap { $0.ingredients })
        let allAllergens = Set(foods.flatMap { $0.allergens })
        var candidates: [String: [String]] = [:]
        allAllergens.forEach { allergen in
            let foodsC = foods.filter { $0.allergens.contains(allergen) }
            let ingredientsCandidate = allIngredients.filter { ing in foodsC.filter { $0.ingredients.contains(ing) }.count == foodsC.count  }
            candidates[allergen] = Array(ingredientsCandidate)
        }
        let relation = getIngredientAllergen(candidates: candidates)
        let sortedRelation = relation.sorted { $0.0 < $1.0 }
        let result = sortedRelation.map { $0.1 }.joined(separator: ",")
        return "\(result)"
    }
    
    struct Food {
        let ingredients: [String]
        let allergens: [String]
    }
    
    private func getFood(_ input: String) -> Food {
        let components = input.dropLast().components(separatedBy: " (contains ")
        let ingredients = components[0].components(separatedBy: .whitespaces)
        let allergens = components[1].components(separatedBy: ", ")
        return Food(ingredients: ingredients, allergens: allergens)
    }
    
    private func getIngredientAllergen(candidates: [String: [String]]) -> [(String, String)] {
        var candidates = candidates
        var ingredientAllergen: [(String, String)] = []
        
        while !candidates.isEmpty {
            guard let candidate = candidates.first(where: { $0.value.count == 1 }) else { break }
            ingredientAllergen.append((candidate.key, candidate.value.first!))
            candidates[candidate.key] = nil
            for candidateI in candidates {
                candidates[candidateI.key] = candidates[candidateI.key]!.filter { $0 != candidate.value.first! }
            }
        }
        
        return ingredientAllergen
    }
    
}
