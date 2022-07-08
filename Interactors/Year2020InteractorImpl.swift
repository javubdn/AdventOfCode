//
//  Year2020InteractorImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 28/6/22.
//

import Foundation

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
        var seats = readCSV("InputYear2020Day11").components(separatedBy: .newlines).map { $0.map { String($0) } }
        var combinations: Set<String> = Set()
        var seatsString = ""
        while true {
            seats = applyStepSeats(seats, true)
            seatsString = seats.map { $0.joined() }.joined()
            if combinations.contains(seatsString) { break }
            combinations.insert(seatsString)
        }
        let result = seatsString.filter { $0 == "#" }.count
        return "\(result)"
    }
    
    @objc
    func day11question2() -> String {
        var seats = readCSV("InputYear2020Day11").components(separatedBy: .newlines).map { $0.map { String($0) } }
        var combinations: Set<String> = Set()
        var seatsString = ""
        while true {
            seats = applyStepSeats(seats, false)
            seatsString = seats.map { $0.joined() }.joined()
            if combinations.contains(seatsString) { break }
            combinations.insert(seatsString)
        }
        let result = seatsString.filter { $0 == "#" }.count
        return "\(result)"
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
    
        return "\(result)"
    }
    
}
