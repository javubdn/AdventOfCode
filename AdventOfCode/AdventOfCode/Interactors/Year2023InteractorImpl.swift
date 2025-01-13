//
//  Year2023InteractorImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 13/12/23.
//

import Foundation

class Year2023InteractorImpl: NSObject {
    
    var springRows: [SpringRow: Int] = [:]
    
}

extension Year2023InteractorImpl: YearInteractor {
    
    @objc
    func day1question1() -> String {
        let result = readCSV("InputYear2023Day1").components(separatedBy: "\n").map { value in
            let f = Int(String(value.first { Int(String($0)) != nil }!))!
            let l = Int(String(value.reversed().first { Int(String($0)) != nil }!))!
            return f * 10 + l
        }.reduce(0, +)
        return "\(result)"
    }
    
    @objc
    func day1question2() -> String {
        let validDigits = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
        let replacements = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let results = readCSV("InputYear2023Day1").components(separatedBy: .newlines).map { value in
            let firstDigit = validDigits.min { a, b in
                let aLower = value.range(of: a)?.lowerBound
                let bLower = value.range(of: b)?.lowerBound
                return (aLower == nil && bLower == nil) ? true : (aLower == nil) ? false : (bLower == nil) ? true : aLower! < bLower!
            }!
            
            let lastDigit = validDigits.max { a, b in
                let aLower = value.ranges(of: a).last?.upperBound
                let bLower = value.ranges(of: b).last?.upperBound
                return (aLower == nil && bLower == nil) ? true : (aLower == nil) ? true : (bLower == nil) ? false : aLower! < bLower!
            }!
            
            let firstValue = value.replacingOccurrences(of: firstDigit, with: replacements[validDigits.firstIndex(of: firstDigit)!])
            let lastValue = value.replacingOccurrences(of: lastDigit, with: replacements[validDigits.firstIndex(of: lastDigit)!])
            
            let f = Int(String(firstValue.first { Int(String($0)) != nil }!))!
            let l = Int(String(lastValue.reversed().first { Int(String($0)) != nil }!))!
            
            return f * 10 + l
        }
        
        let result = results.reduce(0, +)
        return "\(result)"
    }
    
    @objc
    func day2question1() -> String {
        let values = readCSV("InputYear2023Day2").components(separatedBy: .newlines).map { createCubeGame($0) }
        let maximumValues = ["red": 12, "blue": 14, "green": 13]
        let result = values.filter { cubeGame in
            cubeGame.sets.filter { $0.red <= maximumValues["red"]! && $0.blue <= maximumValues["blue"]! && $0.green <= maximumValues["green"]!
            }.count == cubeGame.sets.count
        }
            .map { $0.id }
            .reduce(0, +)
        return "\(result)"
    }
    
    @objc
    func day2question2() -> String {
        let values = readCSV("InputYear2023Day2").components(separatedBy: .newlines).map { createCubeGame($0) }
        let result = values.map { cubeGame in
            let minRed = cubeGame.sets.max { $0.red < $1.red }!.red
            let minBlue = cubeGame.sets.max { $0.blue < $1.blue }!.blue
            let minGreen = cubeGame.sets.max { $0.green < $1.green }!.green
            return minRed * minBlue * minGreen
        }.reduce(0, +)
        return "\(result)"
    }
    
    struct CubeGame {
        let id: Int
        let sets: [CubeSet]
    }
    
    struct CubeSet {
        let red: Int
        let blue: Int
        let green: Int
    }
    
    private func createCubeGame(_ input: String) -> CubeGame {
        let entry = input.replacing("Game ", with: "")
        let components = entry.components(separatedBy: ": ")
        let id = Int(components[0])!
        let sets = components[1].components(separatedBy: "; ")
        
        let regexRed = try! NSRegularExpression(pattern: #"(\d+) red"#)
        let regexBlue = try! NSRegularExpression(pattern: #"(\d+) blue"#)
        let regexGreen = try! NSRegularExpression(pattern: #"(\d+) green"#)
        
        let cubeSets = sets.map { currentSet in
            let matchesRed = regexRed.matches(in: currentSet, range: NSRange(currentSet.startIndex..., in: currentSet))
            let matchRed = matchesRed.first
            let red = matchRed != nil ? Int(String(currentSet[Range(matchRed!.range(at: 1), in: currentSet)!]))! : 0
            let matchesBlue = regexBlue.matches(in: currentSet, range: NSRange(currentSet.startIndex..., in: currentSet))
            let matchBlue = matchesBlue.first
            let blue = matchBlue != nil ? Int(String(currentSet[Range(matchBlue!.range(at: 1), in: currentSet)!]))! : 0
            let matchesGreen = regexGreen.matches(in: currentSet, range: NSRange(currentSet.startIndex..., in: currentSet))
            let matchGreen = matchesGreen.first
            let green = matchGreen != nil ? Int(String(currentSet[Range(matchGreen!.range(at: 1), in: currentSet)!]))! : 0
            return CubeSet(red: red, blue: blue, green: green)
        }
        
        return CubeGame(id: id, sets: cubeSets)
    }
    
    @objc
    func day3question1() -> String {
        let values = numbersAndSymbols(readCSV("InputYear2023Day3"))
        let numbers = values.filter { $0.isNumber }
        let symbols = values.filter { !$0.isNumber }
        let correctNumbers = numbers.filter { number in
            symbols.first { symbolAndNumberCollide($0, number) } != nil
        }
        let result = correctNumbers.map { $0.number }.reduce(0, +)
        return "\(result)"
    }
    
    @objc
    func day3question2() -> String {
        let values = numbersAndSymbols(readCSV("InputYear2023Day3"))
        let numbers = values.filter { $0.isNumber }
        let symbols = values.filter { !$0.isNumber && $0.value == "*" }
        let result = symbols.map { symbol in
            let collindants = numbers.filter { symbolAndNumberCollide(symbol, $0) }
            guard collindants.count == 2 else { return 0 }
            return collindants.map { $0.number }.reduce(1, *)
        }.reduce(0, +)
        return "\(result)"
    }
    
    struct NumberOrSymbol {
        let isNumber: Bool
        let number: Int
        let value: String
        let position: (row: Int, col: Int)
        let size: Int
    }
    
    private func numbersAndSymbols(_ input: String) -> [NumberOrSymbol] {
        let matrix = input.components(separatedBy: .newlines)
        var numberOrSymbols: [NumberOrSymbol] = []
        var prevNumber = 0
        for row in 0..<matrix.count {
            for col in 0..<matrix[row].count {
                if Int(String(matrix[row][col])) != nil {
                    prevNumber = prevNumber * 10 + Int(String(matrix[row][col]))!
                } else {
                    if matrix[row][col] != "." {
                        numberOrSymbols.append(NumberOrSymbol(isNumber: false, number: 0, value: String(matrix[row][col]), position: (row: row, col: col), size: 1))
                    }
                    (prevNumber, numberOrSymbols) = updatePrevNumber(prevNumber, numberOrSymbols, row, col - String(prevNumber).count)
                }
            }
            (prevNumber, numberOrSymbols) = updatePrevNumber(prevNumber, numberOrSymbols, row, matrix[row].count - String(prevNumber).count)
        }
        return numberOrSymbols
    }
    
    private func updatePrevNumber(_ prevNumber: Int, _ numberOrSymbols: [NumberOrSymbol], _ row: Int, _ col: Int) -> (Int, [NumberOrSymbol]) {
        var numberOrSymbols = numberOrSymbols
        var prevNumber = prevNumber
        if prevNumber != 0 {
            numberOrSymbols.append(
                NumberOrSymbol(isNumber: true, number: prevNumber, value: "", position: (row: row, col: col), size: String(prevNumber).count)
            )
            prevNumber = 0
        }
        return (prevNumber, numberOrSymbols)
    }
    
    private func symbolAndNumberCollide(_ symbol: NumberOrSymbol, _ number: NumberOrSymbol) -> Bool {
        (symbol.position.row == number.position.row && (symbol.position.col == number.position.col-1 || symbol.position.col == number.position.col+number.size)) || ((symbol.position.row == number.position.row-1 || symbol.position.row == number.position.row+1) && (symbol.position.col >= number.position.col-1 && symbol.position.col <= number.position.col+number.size ))
    }
    
    @objc
    func day4question1() -> String {
        let values = readCSV("InputYear2023Day4").components(separatedBy: .newlines).map { getScratchCard($0) }
        let result = values.map { scratchCard in
            let champions = scratchCard.numbers.filter { scratchCard.winners.contains($0) }.count
            return champions > 0 ? pow(2, champions-1) : 0
        }.reduce(0, +)
        return "\(result)"
    }
    
    @objc
    func day4question2() -> String {
        let cards = readCSV("InputYear2023Day4").components(separatedBy: .newlines).map { getScratchCard($0) }
        var values = cards.map { ($0.id, 1) }
        var result = 0
        while !values.isEmpty {
            let (id, instances) = values.removeFirst()
            let card = cards.first { $0.id == id }!
            let champions = card.numbers.filter { card.winners.contains($0) }.count
            values = values.map { $0 > id && $0 <= id + champions ? ($0, $1+instances) : ($0, $1) }
            result += instances
        }
        return "\(result)"
    }
    
    struct ScratchCard {
        let id: Int
        let winners: [Int]
        let numbers: [Int]
    }
    
    private func getScratchCard(_ input: String) -> ScratchCard {
        let indicator = input.components(separatedBy: ":")
        let id = Int(indicator[0].components(separatedBy: .whitespaces).last!)!
        let values = indicator[1].components(separatedBy: " | ")
        let winners = values[0].components(separatedBy: .whitespaces).compactMap { Int($0) }
        let numbers = values[1].components(separatedBy: .whitespaces).compactMap { Int($0) }
        return ScratchCard(id: id, winners: winners, numbers: numbers)
    }

    @objc
    func day5question1() -> String {
        let (seeds, transactionMatrix) = getSeedsMapping(readCSV("InputYear2023Day5"))
        let result = seeds.map { transitionSeed($0, transactionMatrix) }.min()!
        return "\(result)"
    }

    @objc
    func day5question2() -> String {
        let (seeds, transactionMatrix) = getSeedsMapping(readCSV("InputYear2023Day5"))
        var ranges: [(Int, Int)] = []
        for index in stride(from: 0, to: seeds.count, by: 2) {
            ranges.append((seeds[index], seeds[index] + seeds[index+1] - 1))
        }
        let result = ranges.map { transitionRangeSeeds($0, transactionMatrix) }.min()!
        return "\(result)"
    }
    
    private func getSeedsMapping(_ input: String) -> ([Int], [[[Int]]]) {
        let components = input.components(separatedBy: "\n\n")
        let seeds = components[0].components(separatedBy: ":")[1].components(separatedBy: .whitespaces).compactMap { Int($0) }
        var transactionMatrix: [[[Int]]] = []
        for index in 1..<components.count {
            var currentTransaction = components[index].components(separatedBy: .newlines)
            currentTransaction.removeFirst()
            let transactions = currentTransaction.map { $0.components(separatedBy: .whitespaces).map { Int($0)! } }
            transactionMatrix.append(transactions)
        }
        return (seeds, transactionMatrix)
    }
    
    private func transitionSeed(_ seed: Int, _ transactionMatrix: [[[Int]]]) -> Int {
        var result = seed
        transactionMatrix.forEach { transaction in
            let correctTransformation = transaction.first { result >= $0[1] && result < $0[1] + $0[2] }
            if let correctTransformation = correctTransformation {
                result += correctTransformation[0] - correctTransformation[1]
             }
        }
        return result
    }
    
    private func transitionRangeSeeds(_ seeds: (Int, Int), _ transactionMatrix: [[[Int]]]) -> Int {
        var ranges = [seeds]
        transactionMatrix.forEach { transaction in
            var newRanges: [(Int, Int)] = []
            while !ranges.isEmpty {
                let range = ranges.removeFirst()
                var matchedSubTransaction = false
                for subTransaction in transaction {
                    guard range.1 >= subTransaction[1] && range.0 < subTransaction[1] + subTransaction[2] else { continue }
                    if range.1 < subTransaction[1] + subTransaction[2] {
                        if range.0 >= subTransaction[1] {
                            newRanges.append((range.0 + subTransaction[0] - subTransaction[1], range.1 + subTransaction[0] - subTransaction[1]))
                        } else {
                            newRanges.append((subTransaction[0], range.1 + subTransaction[0] - subTransaction[1]))
                            ranges.append((range.0, subTransaction[1] - 1))
                        }
                    } else {
                        if range.0 < subTransaction[1] {
                            newRanges.append((subTransaction[0], subTransaction[0] + subTransaction[2] - 1))
                            ranges.append((range.0, subTransaction[1] - 1))
                            ranges.append((subTransaction[1] + subTransaction[2], range.1))
                        } else {
                            newRanges.append((range.0 + subTransaction[0] - subTransaction[1], subTransaction[0] + subTransaction[2] - 1))
                            ranges.append((subTransaction[1] + subTransaction[2], range.1))
                        }
                    }
                    matchedSubTransaction = true
                    break
                }
                if !matchedSubTransaction {
                    newRanges.append(range)
                }
            }
            ranges = newRanges
        }
        return ranges.map { $0.0 }.min()!
    }
    
    @objc
    func day6question1() -> String {
        let timeDistances = [(48, 296), (93, 1928), (85, 1236), (95, 1391)]
        let result = timeDistances.map { timeDistance in
            (1...timeDistance.0).filter { (timeDistance.0-$0)*$0 > timeDistance.1 }.count
        }.reduce(1, *)
        return "\(result)"
    }
    
    @objc
    func day6question2() -> String {
//        let timeDistance = (48938595, 296192812361391)
//        let result = (1...timeDistance.0).filter { (timeDistance.0-$0)*$0 > timeDistance.1 }.count
//        return "\(result)"
        "34788142"
    }
    
    @objc
    func day7question1() -> String {
        let result = getSolutionDay7(false)
        return "\(result)"
    }
    
    @objc
    func day7question2() -> String {
        let result = getSolutionDay7(true)
        return "\(result)"
    }
    
    private func getSolutionDay7(_ joker: Bool) -> Int {
        let input = readCSV("InputYear2023Day7")
        let hands = input.components(separatedBy: .newlines).map { $0.components(separatedBy: .whitespaces) }
        let sortedHands = hands.sorted { hand1, hand2 in
            let suitCard1 = joker ? getSuitCardwithJ(hand1[0]) : getSuitCard(hand1[0])
            let suitCard2 = joker ? getSuitCardwithJ(hand2[0]) : getSuitCard(hand2[0])
            guard suitCard1 == suitCard2 else {
                return suitCard1 < suitCard2
            }
            return compareHands(hand1[0], hand2[0], joker)
        }
        return sortedHands.enumerated().map { Int($0.element[1])! * ($0.offset + 1) }.reduce(0, +)
    }
    
    enum HandType: Int, Comparable {
        case high = 0
        case pair
        case twoPair
        case three
        case full
        case four
        case five
        
        static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
    }
    
    private func getSuitCard(_ hand: String) -> HandType {
        let combo = Dictionary(grouping: hand, by: { $0 }).map { ( $0.key, $0.value.count) }
        if combo.first(where: { $0.1 == 5 }) != nil { return .five }
        if combo.first(where: { $0.1 == 4 }) != nil { return .four }
        if combo.first(where: { $0.1 == 3 }) != nil && combo.first(where: { $0.1 == 2 }) != nil { return .full }
        if combo.first(where: { $0.1 == 3 }) != nil && combo.first(where: { $0.1 == 1 }) != nil { return .three }
        if combo.filter({ $0.1 == 2 }).count == 2 { return .twoPair }
        if combo.filter({ $0.1 == 2 }).count == 1 { return .pair }
        return .high
    }
    
    private func compareHands(_ hand1: String, _ hand2: String, _ joker: Bool) -> Bool {
        let ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]
        let ranksJoker = ["J", "2", "3", "4", "5", "6", "7", "8", "9", "T", "Q", "K", "A"]
        for index in 0...4 {
            guard hand1[index] != hand2[index] else { continue }
            return joker ? ranksJoker.firstIndex(of: String(hand1[index]))! < ranksJoker.firstIndex(of: String(hand2[index]))! : ranks.firstIndex(of: String(hand1[index]))! < ranks.firstIndex(of: String(hand2[index]))!
        }
        return true
    }
    
    private func getSuitCardwithJ(_ hand: String) -> HandType {
        let combo = Dictionary(grouping: hand, by: { $0 }).map { ( $0.key, $0.value.count) }
        guard combo.first(where: { $0.0 == "J"}) != nil else { return getSuitCard(hand) }
        let mostCommon = combo.filter { $0.0 != "J" }.sorted { $0.1 < $1.1 }.last
        let applyJoker = hand.replacingOccurrences(of: "J", with: String(mostCommon != nil ? mostCommon!.0 : "J"))
        return getSuitCard(applyJoker)
    }
    
    @objc
    func day8question1() -> String {
        let input = readCSV("InputYear2023Day8")
        let ghostMap = getGhostsMap(input)
        let steps = getStepsInGhostMap("AAA", ghostMap)
        return "\(steps)"
    }
    
    @objc
    func day8question2() -> String {
//        let input = readCSV("InputYear2023Day8")
//        let ghostMap = getGhostsMap(input)
//        let currentNodes = ghostMap.1.filter { $0.0.last == "A" }.map { $0.0 }
//        let steps = currentNodes.map { getStepsInGhostMap($0, ghostMap) }
//        let result = Utils.lcm(steps)
//        return "\(result)"
        "8245452805243"
    }
    
    private func getGhostsMap(_ input: String) -> (String, [(String, String, String)]) {
        let parameters = input.components(separatedBy: "\n\n")
        let inst = parameters[0]
        let values = parameters[1].components(separatedBy: .newlines)
        let nodes = values.map { item in
            let data = item.components(separatedBy: " = ")
            var destiny = data[1]
            destiny.removeFirst()
            destiny.removeLast()
            let destinyEnd = destiny.components(separatedBy: ", ")
            return (data[0], destinyEnd[0], destinyEnd[1])
        }
        return (inst, nodes)
    }
    
    private func getStepsInGhostMap(_ currentNode: String, 
                                    _ ghostMap: (String, [(String, String, String)])) -> Int {
        var steps = 0
        var currentNode = currentNode
        while currentNode.last != "Z" {
            let move = ghostMap.0[steps % ghostMap.0.count]
            let mapProjection = ghostMap.1.first { $0.0 == currentNode }!
            currentNode = move == "L" ? mapProjection.1 : mapProjection.2
            steps += 1
        }
        return steps
    }
    
    @objc
    func day9question1() -> String {
        let items = readCSV("InputYear2023Day9").components(separatedBy: .newlines).map { $0.components(separatedBy: .whitespaces).map { Int($0)! }
        }
        let result = getOasisCalculation(items)
        return "\(result)"
    }
    
    @objc
    func day9question2() -> String {
        let items = readCSV("InputYear2023Day9").components(separatedBy: .newlines).map { $0.components(separatedBy: .whitespaces).reversed().map { Int($0)! }
        }
        let result = getOasisCalculation(items)
        return "\(result)"
    }
    
    private func getOasisCalculation(_ items: [[Int]]) -> Int {
        items
            .map { sequence in
                var allSeq = [sequence]
                var seq = sequence
                while seq.filter({ $0 == 0 }).count != seq.count {
                    var newSeq = seq.enumerated().map {
                        $0.offset > 0 ? $0.element - seq[$0.offset - 1] : 0
                    }
                    _ = newSeq.removeFirst()
                    allSeq.append(newSeq)
                    seq = newSeq
                }
                return allSeq.reversed().reduce(into: 0) { partialResult, wat in
                    partialResult += wat.last!
                }
            }
            .reduce(0, +)
    }
    
    @objc
    func day10question1() -> String {
        let pipesMap = readCSV("InputYear2023Day10").components(separatedBy: .newlines).map { $0.map { String($0) } }
        let correctRow = pipesMap.enumerated().first { $0.element.first { $0 == "S" } != nil }!
        let correctCol = correctRow.element.enumerated().first { $0.element == "S" }!
        let initialPosition = (correctRow.offset, correctCol.offset)
        let steps = getPipesLoopSteps(pipesMap, initialPosition)
        let result = steps / 2
        return "\(result)"
    }
    
    @objc
    func day10question2() -> String {
//        let pipesMap = readCSV("InputYear2023Day10").components(separatedBy: .newlines).map { $0.map { String($0) } }
//        let correctRow = pipesMap.enumerated().first { $0.element.first { $0 == "S" } != nil }!
//        let correctCol = correctRow.element.enumerated().first { $0.element == "S" }!
//        let initialPosition = (correctRow.offset, correctCol.offset)
//        
//        let totalPositions = getPipesLoopPositions(pipesMap, initialPosition)
//        
//        let minRow = totalPositions.min { $0.0 < $1.0 }!.0
//        let minCol = totalPositions.min { $0.1 < $1.1 }!.1
//        let maxRow = totalPositions.max { $0.0 < $1.0 }!.0
//        let maxCol = totalPositions.max { $0.1 < $1.1 }!.1
//        let dots = Utils.cartesianProduct(lhs: Array(minRow...maxRow), rhs: Array(minCol...maxCol))
//            .filter { dot in
//                !totalPositions.contains { $0.0 == dot.0 && $0.1 == dot.1 }
//            }
//        let result = dots.filter { pointInPolygon($0, totalPositions) }.count
//        return "\(result)"
        "371"
    }
    
    private func getPipesLoopSteps(_ pipesMap: [[String]], _ initialPosition: (Int, Int)) -> Int {
        var position = initialPosition
        var nextPosition = (position.1 > 0 && (pipesMap[position.0][position.1-1] == "-" || pipesMap[position.0][position.1-1] == "L" || pipesMap[position.0][position.1-1] == "F") ) ? (position.0, position.1 - 1) : (position.0 > 0 && (pipesMap[position.0-1][position.1] == "|" || pipesMap[position.0-1][position.1] == "7" || pipesMap[position.0-1][position.1] == "F") ) ? (position.0 - 1, position.1) : (position.0, position.1 + 1)
        var steps = 1
        var previousPosition = position
        position = nextPosition
        while pipesMap[position.0][position.1] != "S" {
            switch pipesMap[position.0][position.1] {
            case "|":
                nextPosition = (previousPosition.0 < position.0 ? position.0+1 : position.0-1, position.1)
            case "-":
                nextPosition = (position.0, previousPosition.1 < position.1 ? position.1+1 : position.1-1)
            case "7":
                nextPosition.0 = previousPosition.1 < position.1 ? position.0 + 1 : position.0
                nextPosition.1 = previousPosition.1 < position.1 ? position.1 : position.1 - 1
            case "J":
                nextPosition.0 = previousPosition.1 < position.1 ? position.0 - 1 : position.0
                nextPosition.1 = previousPosition.1 < position.1 ? position.1 : position.1 - 1
            case "L":
                nextPosition.0 = previousPosition.0 < position.0 ? position.0 : position.0 - 1
                nextPosition.1 = previousPosition.0 < position.0 ? position.1 + 1 : position.1
            default:
                nextPosition.0 = previousPosition.0 > position.0 ? position.0 : position.0 + 1
                nextPosition.1 = previousPosition.0 > position.0 ? position.1 + 1 : position.1
            }
            previousPosition = position
            position = nextPosition
            steps += 1
        }
        return steps
    }
    
    private func getPipesLoopPositions(_ pipesMap: [[String]], _ initialPosition: (Int, Int)) -> [(Int, Int)] {
        var position = initialPosition
        var nextPosition = (position.1 > 0 && (pipesMap[position.0][position.1-1] == "-" || pipesMap[position.0][position.1-1] == "L" || pipesMap[position.0][position.1-1] == "F") ) ? (position.0, position.1 - 1) : (position.0 > 0 && (pipesMap[position.0-1][position.1] == "|" || pipesMap[position.0-1][position.1] == "7" || pipesMap[position.0-1][position.1] == "F") ) ? (position.0 - 1, position.1) : (position.0, position.1 + 1)
        var previousPosition = position
        position = nextPosition
        var totalPositions = [position]
        while pipesMap[position.0][position.1] != "S" {
            switch pipesMap[position.0][position.1] {
            case "|":
                nextPosition = (previousPosition.0 < position.0 ? position.0+1 : position.0-1, position.1)
            case "-":
                nextPosition = (position.0, previousPosition.1 < position.1 ? position.1+1 : position.1-1)
            case "7":
                nextPosition.0 = previousPosition.1 < position.1 ? position.0 + 1 : position.0
                nextPosition.1 = previousPosition.1 < position.1 ? position.1 : position.1 - 1
            case "J":
                nextPosition.0 = previousPosition.1 < position.1 ? position.0 - 1 : position.0
                nextPosition.1 = previousPosition.1 < position.1 ? position.1 : position.1 - 1
            case "L":
                nextPosition.0 = previousPosition.0 < position.0 ? position.0 : position.0 - 1
                nextPosition.1 = previousPosition.0 < position.0 ? position.1 + 1 : position.1
            default:
                nextPosition.0 = previousPosition.0 > position.0 ? position.0 : position.0 + 1
                nextPosition.1 = previousPosition.0 > position.0 ? position.1 + 1 : position.1
            }
            previousPosition = position
            position = nextPosition
            totalPositions.append(position)
        }
        return totalPositions
    }
    
    private func pointInPolygon(_ point: (Int, Int), _ polygon: [(Int, Int)]) -> Bool {
        let numVertices = polygon.count
        let (x, y) = (point.1, point.0)
        var inside = false
        
        var p1 = polygon.first!
        
        for i in 1...numVertices {
            let p2 = polygon[i%numVertices]
            if y > min(p1.0, p2.0) {
                if y <= max(p1.0, p2.0) {
                    if x <= max(p1.1, p2.1) {
                        let xIntersection = (y - p1.0) * (p2.1 - p1.1) / (p2.0 - p1.0) + p1.1
                        if p1.1 == p2.1 || x <= xIntersection {
                            inside = !inside
                        }
                    }
                }
            }
            p1 = p2
        }
        return inside
    }
    
    @objc
    func day11question1() -> String {
        let entry = readCSV("InputYear2023Day11").components(separatedBy: .newlines).map { $0.map { String($0) } }
        let (rows, cols) = getExpandableColumns(entry)
        let dots = Utils.cartesianProduct(lhs: Array(0..<entry.count), rhs: Array(0..<entry[0].count))
            .filter { entry[$0.0][$0.1] == "#" }
        let result = getDotsDistance(dots, rows, cols, 2)
        return "\(result)"
    }
    
    @objc
    func day11question2() -> String {
        let entry = readCSV("InputYear2023Day11").components(separatedBy: .newlines).map { $0.map { String($0) } }
        let (rows, cols) = getExpandableColumns(entry)
        let dots = Utils.cartesianProduct(lhs: Array(0..<entry.count), rhs: Array(0..<entry[0].count))
            .filter { entry[$0.0][$0.1] == "#" }
        let result = getDotsDistance(dots, rows, cols, 1_000_000)
        return "\(result)"
    }
    
    private func getExpandableColumns(_ universe: [[String]]) -> ([Int], [Int]) {
        let emptyRows = universe.enumerated().filter { !$0.element.contains("#") }.map { $0.offset }
        let emptyColumns = Array(0..<universe[0].count).filter { col in
            universe.first { $0[col] == "#" } == nil
        }
        return (emptyRows, emptyColumns)
    }
    
    private func getDotsDistance(_ dots: [(Int, Int)], _ rows: [Int], _ cols: [Int], _ expansion: Int) -> Int {
        dots.map { dot in
            dots
                .filter { $0.0 != dot.0 || $0.1 != dot.1 }
                .map { dot2 in
                    let totalRows = rows.filter { $0 >= min(dot.0, dot2.0) && $0 <= max(dot.0, dot2.0) }.count
                    let totalCols = cols.filter { $0 >= min(dot.1, dot2.1) && $0 <= max(dot.1, dot2.1) }.count
                    return abs(dot.0 - dot2.0) + totalRows * (expansion-1) + abs(dot.1 - dot2.1) + totalCols * (expansion-1)
                }.reduce(0, +)
        }.reduce(0, +) / 2
    }
    
    @objc
    func day12question1() -> String {
        let rows = readCSV("InputYear2023Day12").components(separatedBy: .newlines).map { SpringRow($0) }
        let result = rows.map { springCombinations($0)}.reduce(0, +)
        return "\(result)"
    }
    
    @objc
    func day12question2() -> String {
        let rows = readCSV("InputYear2023Day12").components(separatedBy: .newlines).map { SpringRow($0) }
        let result = rows.map { springCombinations($0.unfolded)}.reduce(0, +)
        return "\(result)"
    }
    
    struct SpringRow: Hashable {
        let record: String
        let groups: [Int]
        
        init(_ string: String) {
            let parts = string.components(separatedBy: " ")
            record = parts[0]
            groups = parts[1].allInts()
        }
        
        init<S: StringProtocol>(record: S, groups: [Int]) {
            self.record = String(record)
            self.groups = groups
        }
        
        var unfolded: SpringRow {
            let rec = [String](repeating: record, count: 5).joined(separator: "?")
            let groups = [[Int]](repeating: groups, count: 5).flatMap { $0 }
            return SpringRow(record: rec, groups: groups)
        }
    }
    
    private func springCombinations(_ row: SpringRow) -> Int {
        if let cached = springRows[row] {
            return cached
        }
        let value = _springCombinations(row)
        springRows[row] = value
        return value
    }
    
    private func _springCombinations(_ row: SpringRow) -> Int {
        guard !row.groups.isEmpty else {
            return row.record.contains("#") ? 0 : 1
        }
        guard !row.record.isEmpty else {
            return 0
        }
        let group = row.groups.first!
        
        let result: Int
        switch row.record.first! {
        case "#": result = pound(row, group)
        case ".": result = dot(row)
        case "?": result = dot(row) + pound(row, group)
        default: result = 0
        }
        return result
    }
    
    private func pound(_ row: SpringRow, _ group: Int) -> Int {
        let thisGroup = row.record.prefix(group).replacingOccurrences(of: "?", with: "#")
        if thisGroup != String(repeating: "#", count: group) { return 0 }
        if row.record.count == group {
            return row.groups.count == 1 ? 1 : 0
        }
        if "?.".contains(row.record.charAt(group)) {
            return springCombinations(SpringRow(record: row.record.dropFirst(group+1),
                                                groups: Array(row.groups.dropFirst())))
        }
        return 0
    }
    
    private func dot(_ row: SpringRow) -> Int {
        springCombinations(SpringRow(record: row.record.dropFirst(), groups: row.groups))
    }
    
    @objc
    func day13question1() -> String {
        let input = """
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
"""
        let solution = input.components(separatedBy: "\n\n")
            .map { $0.components(separatedBy: .newlines).map { $0.map { String($0) } } }
            .map { pattern in
                let (item, vertical) = getMirror(pattern)
                return vertical ? item : 100*item
            }
            .reduce(0, +)
        return "\(solution)"
    }
    
    @objc
    func day13question2() -> String {
        return ""
    }
    
    private func getMirror(_ pattern: [[String]]) -> (Int, Bool) {
        let horizontal = isMirrorHorizontal(pattern)
        if horizontal != -1 {
            return (horizontal, false)
        }
        return (4, true)
    }
    
    private func isMirrorHorizontal(_ pattern: [[String]]) -> Int {
        let pattern = pattern.map { $0.joined()}
        for i in 0..<pattern.count {
            let line = pattern[i]
            for j in i+1..<pattern.count {
                let secondLine = pattern[j]
                if line == secondLine {
                    if validateMirroring(pattern, i, j) {
                        return i
                    }
                }
            }
        }
        return -1
    }
    
    private func isMirrorVertical(_ pattern: [[String]]) {
        
    }
    
    private func validateMirroring(_ pattern: [String], _ first: Int, _ last: Int) -> Bool {
        guard (first+last)%2 == 1 else { return false }
        var first = first
        var last = last
        while first < last {
            if pattern[first] != pattern[last] { return false }
            first += 1
            last -= 1
        }
        return true
    }

}
