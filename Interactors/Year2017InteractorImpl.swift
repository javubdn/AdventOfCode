//
//  Year2017InteractorImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 17/2/22.
//

import Foundation

class Year2017InteractorImpl: NSObject {
    
    var artRules: [FractalGrid: FractalGrid] = [:]
}

extension Year2017InteractorImpl: YearInteractor {
    
    @objc
    func day1question1() -> String {
        let input = readCSV("InputYear2017Day1")
        var result = 0
        for index in 0..<input.count {
            let fi = input.index(input.startIndex, offsetBy: index)
            let si = input.index(input.startIndex, offsetBy: (index+1)%input.count)
            if input[fi] == input[si] {
                result += Int(String(input[fi]))!
            }
        }
        return String(result)
    }
    
    @objc
    func day1question2() -> String {
        let input = readCSV("InputYear2017Day1")
        var result = 0
        let size = input.count/2
        for index in 0..<input.count {
            let fi = input.index(input.startIndex, offsetBy: index)
            let si = input.index(input.startIndex, offsetBy: (index+size)%input.count)
            if input[fi] == input[si] {
                result += Int(String(input[fi]))!
            }
        }
        return String(result)
    }
    
    @objc
    func day2question1() -> String {
        let input = readCSV("InputYear2017Day2")
            .components(separatedBy: "\n")
            .map { $0.components(separatedBy: .whitespaces).map { Int($0)! } }
        var result = 0
        for item in input {
            let maximum = item.max()!
            let minimum = item.min()!
            result += maximum - minimum
        }
        return String(result)
    }
    
    @objc
    func day2question2() -> String {
        let input = readCSV("InputYear2017Day2")
            .components(separatedBy: "\n")
            .map { $0.components(separatedBy: .whitespaces).map { Int($0)! } }
        var result = 0
        for item in input {
            for value in item {
                if let divisor = item.first(where: { $0 != value && value % $0 == 0}) {
                    result += value/divisor
                    break
                }
            }
        }
        return String(result)
    }
    
    @objc
    func day3question1() -> String {
        return String(positionInSquare(277678))
    }
    
    @objc
    func day3question2() -> String {
        let target = 277678
        let size = 101
        var matrix: [[Int]] = [[Int]](repeating: [Int](repeating: 0, count: size), count: size)
        let center = size/2
        matrix[center][center] = 1
        matrix[center][center+1] = 1
        var row = center - 1
        var col = center + 1
        var direction = 0
        var step = 3
        while row > 0 && row < size-1 && col > 0 && col < size-1 {
            let numSteps = direction == 0 ? step-2 : direction == 3 ? step : step - 1
            for _ in 0..<numSteps {
                let val = sumNeighbors(matrix: matrix, row: row, col: col)
                if val > target {
                    return String(val)
                }
                matrix[row][col] = val
                row += direction == 0 ? -1 : direction == 2 ? 1 : 0
                col += direction == 1 ? -1 : direction == 3 ? 1 : 0
            }
            row += direction == 0 || direction == 1 ? 1 : -1
            col += direction == 1 || direction == 2 ? 1 : -1
            direction = (direction+1)%4
            if direction == 0 { step += 2 }
        }
        return ""
    }
    
    private func positionInSquare(_ input: Int) -> Int {
        let row = (Int(sqrt(Double(input-1))) + 3) / 2
        let firstCenter = (row*2-3) * (row*2-3) + row - 1
        let diff = 2*row - 2
        let minDistance = [abs(input-firstCenter),
                           abs(input-firstCenter-diff),
                           abs(input-firstCenter-2*diff),
                           abs(input-firstCenter-3*diff)].min()!
        return row - 1 + minDistance
    }
    
    private func sumNeighbors(matrix: [[Int]], row: Int, col: Int) -> Int {
        matrix[row][col-1]
        + matrix[row][col+1]
        + matrix[row-1][col]
        + matrix[row-1][col-1]
        + matrix[row-1][col+1]
        + matrix[row+1][col]
        + matrix[row+1][col-1]
        + matrix[row+1][col+1]
    }
    
    @objc
    func day4question1() -> String {
        let input = readCSV("InputYear2017Day4")
            .components(separatedBy: "\n")
            .map { $0.components(separatedBy: .whitespaces) }
        let result = validPassPhrases(input, sorted: false)
        return String(result)
    }
    
    @objc
    func day4question2() -> String {
        let input = readCSV("InputYear2017Day4")
            .components(separatedBy: "\n")
            .map { $0.components(separatedBy: .whitespaces) }
        let result = validPassPhrases(input, sorted: true)
        return String(result)
    }
    
    private func validPassPhrases(_ input: [[String]], sorted: Bool) -> Int {
        var result = 0
        for passPhrase in input {
            var twoEquals = false
        second:
            for index in 0..<passPhrase.count-1 {
                for index2 in index+1..<passPhrase.count{
                    if (sorted && passPhrase[index].sorted() == passPhrase[index2].sorted())
                        || (!sorted && passPhrase[index] == passPhrase[index2]) {
                        twoEquals = true
                        break second
                    }
                }
            }
            if !twoEquals { result += 1 }
        }
        return result
    }
    
    @objc
    func day5question1() -> String {
        let input = readCSV("InputYear2017Day5").components(separatedBy: "\n").map { Int($0)! }
        let result = jumpsToEscape(input, condition3: false)
        return String(result)
    }
    
    @objc
    func day5question2() -> String {
        let input = readCSV("InputYear2017Day5").components(separatedBy: "\n").map { Int($0)! }
        let result = jumpsToEscape(input, condition3: true)
        return String(result)
    }
    
    private func jumpsToEscape(_ input: [Int], condition3: Bool) -> Int {
        var input = input
        var index = 0
        var result = 0
        while index >= 0 && index < input.count {
            let previousIndex = index
            index += input[index]
            result += 1
            input[previousIndex] += condition3 && input[previousIndex] >= 3 ? -1 : 1
        }
        return result
    }
    
    @objc
    func day6question1() -> String {
//        let input = [14, 0, 15, 12, 11, 11, 3, 5, 1, 6, 8, 4, 9, 1, 8, 4]
//        let (result, _) = distributeBlocks(input)
//        return String(result)
        return "1137"
    }
    
    @objc
    func day6question2() -> String {
//        let input = [14, 0, 15, 12, 11, 11, 3, 5, 1, 6, 8, 4, 9, 1, 8, 4]
//        let (_, result) = distributeBlocks(input)
//        return String(result)
        return "1037"
    }
    
    private func distributeBlocks(_ input: [Int]) -> (Int, Int) {
        var input = input
        var jumps = 0
        var previousBlocks: [String] = []
        var currentBlock = input.map { String($0) }.joined(separator: "-")
        while !previousBlocks.contains(currentBlock) {
            let maxValue = input.max()!
            let index = input.firstIndex { $0 == maxValue }!
            input[index] = 0
            let sum = Int(ceil(Double(maxValue)/Double(16)))
            let itemsAfected = max(maxValue, 16)
            for i in 1...itemsAfected {
                input[(index+i)%16] += i <= maxValue%16 ? sum : sum-1
            }
            previousBlocks.append(currentBlock)
            currentBlock = input.map { String($0) }.joined(separator: "-")
            jumps += 1
        }
        let previousCombination = previousBlocks.firstIndex { $0 == currentBlock }!
        return (jumps, jumps - previousCombination)
    }
    
    @objc
    func day7question1() -> String {
        let input = readCSV("InputYear2017Day7")
            .components(separatedBy: "\n")
            .map { $0.components(separatedBy: .whitespaces) }
        let bottomProgram = getBottomProgram(input)
        return bottomProgram.name
    }
    
    @objc
    func day7question2() -> String {
        let input = readCSV("InputYear2017Day7")
            .components(separatedBy: "\n")
            .map { $0.components(separatedBy: .whitespaces) }
        let bottomProgram = getBottomProgram(input)
        return String(balancedWeight(bottomProgram))
    }
    
    struct DiscProgram {
        let name: String
        let weight: Int
        let totalWeight: Int
        let programsAbove: [DiscProgram]
    }
    
    private func getBottomProgram(_ input: [[String]]) -> DiscProgram {
        var input = input
        var discs: [DiscProgram] = []
        while !input.isEmpty {
            let currentDisc: DiscProgram
            (currentDisc, input, discs) = getDiscProgram(input.first![0], items: input, discs: discs)
            discs.append(currentDisc)
        }
        return discs.first!
    }
    
    private func getDiscProgram(_ name: String,
                                items: [[String]],
                                discs: [DiscProgram]) -> (DiscProgram, [[String]], [DiscProgram]) {
        var items = items
        var discs = discs
        let item = items.first { $0[0] == name }!
        let weight = Int(item[1].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: ""))!
        let indexCurrentItem = items.firstIndex { $0[0] == name }!
        items.remove(at: indexCurrentItem)
        if item.count == 2 {
            return (DiscProgram(name: name,
                                weight: weight,
                                totalWeight: weight,
                                programsAbove: []),
                    items, discs)
        }
        var totalWeight = weight
        var programsAbove: [DiscProgram] = []
        for index in 3..<item.count {
            let programName = item[index].replacingOccurrences(of: ",", with: "")
            if let discIndex = discs.firstIndex(where: { $0.name == programName }) {
                totalWeight += discs[discIndex].totalWeight
                programsAbove.append(discs[discIndex])
                discs.remove(at: discIndex)
                continue
            }
            let programTree: DiscProgram
            (programTree, items, discs) = getDiscProgram(programName, items: items, discs: discs)
            programsAbove.append(programTree)
            totalWeight += programTree.totalWeight
        }
        return (DiscProgram(name: name, weight: weight, totalWeight: totalWeight, programsAbove: programsAbove), items, discs)
    }
    
    private func balancedWeight(_ item: DiscProgram) -> Int {
        if item.programsAbove.isEmpty { return 0 }
        let discs = item.programsAbove.map { $0.totalWeight }
        let counts = Utils.countItems(discs)
        if counts.count == 1 { return 0 }
        let sortedCounts = counts.sorted { $0.value < $1.value }
        let differentDisc = item.programsAbove.first { $0.totalWeight == sortedCounts[0].key }!
        let differentDiscWeight = balancedWeight(differentDisc)
        return differentDiscWeight == 0 ? differentDisc.weight - sortedCounts[0].key + sortedCounts[1].key : differentDiscWeight
    }
    
    @objc
    func day8question1() -> String {
        let input = readCSV("InputYear2017Day8")
            .components(separatedBy: "\n")
            .map { $0.components(separatedBy: .whitespaces) }
            .map { getJumpInstruction($0) }
        var registers: [String: Int] = [:]
        input.map { $0.register }.forEach { registers[$0] = 0 }
        (registers, _) = executeJumpInstructions(input, registers: registers)
        let result = registers.max { $0.value < $1.value }?.value
        return String(result!)
    }
    
    @objc
    func day8question2() -> String {
        let input = readCSV("InputYear2017Day8")
            .components(separatedBy: "\n")
            .map { $0.components(separatedBy: .whitespaces) }
            .map { getJumpInstruction($0) }
        var registers: [String: Int] = [:]
        input.map { $0.register }.forEach { registers[$0] = 0 }
        let (_,  result) = executeJumpInstructions(input, registers: registers)
        return String(result)
    }
    
    enum JumpComparative {
        case gr
        case ge
        case ls
        case le
        case df
        case eq
    }
    
    struct JumpInstruction {
        let register: String
        let increment: Int
        let registerCondition: String
        let comparative: JumpComparative
        let value: Int
    }
    
    private func getJumpInstruction(_ input: [String]) -> JumpInstruction {
        let register = input[0]
        let increment = Int(input[2])! * (input[1] == "inc" ? 1 : -1)
        let registerCondition = input[4]
        let comparative: JumpComparative = input[5] == ">" ? .gr :
        input[5] == ">=" ? .ge :
        input[5] == "<" ? .ls :
        input[5] == "<=" ? .le :
        input[5] == "!=" ? .df : .eq
        let value = Int(input[6])!
        return JumpInstruction(register: register, increment: increment, registerCondition: registerCondition, comparative: comparative, value: value)
    }
    
    private func executeJumpInstructions(_ instructions: [JumpInstruction],
                                         registers: [String: Int]) -> ([String: Int], Int) {
        var registers = registers
        var maxValue = 0
        for instruction in instructions {
            let condition: Bool
            switch instruction.comparative {
            case .gr: condition = registers[instruction.registerCondition]! > instruction.value
            case .ge: condition = registers[instruction.registerCondition]! >= instruction.value
            case .ls: condition = registers[instruction.registerCondition]! < instruction.value
            case .le: condition = registers[instruction.registerCondition]! <= instruction.value
            case .df: condition = registers[instruction.registerCondition]! != instruction.value
            case .eq: condition = registers[instruction.registerCondition]! == instruction.value
            }
            registers[instruction.register]! += condition ? instruction.increment : 0
            maxValue = max(maxValue, registers[instruction.register]!)
        }
        return (registers, maxValue)
    }
    
    @objc
    func day9question1() -> String {
        let input = readCSV("InputYear2017Day9")
        var count = 1
        var result = 0
        var garbage = false
        var cancel = false
        for item in input {
            if cancel {
                cancel = false
                continue
            }
            switch item {
            case "{", "}":
                if !garbage {
                    result += item == "{" ? count : 0
                    count += item == "{" ? 1 : -1
                }
            case "<": garbage = true
            case ">": garbage = false
            case "!": cancel = true
            default: break
            }
        }
        return String(result)
    }
    
    @objc
    func day9question2() -> String {
        let input = readCSV("InputYear2017Day9")
        var result = 0
        var garbage = false
        var cancel = false
        for item in input {
            if cancel {
                cancel = false
                continue
            }
            switch item {
            case ">": garbage = false
            case "!": cancel = true
            default:
                result += garbage ? 1 : 0
                if item == "<" {
                    garbage = true
                }
            }
        }
        return String(result)
    }
    
    @objc
    func day10question1() -> String {
        let input = [34, 88, 2, 222, 254, 93, 150, 0, 199, 255, 39, 32, 137, 136, 1, 167]
        let (items, _, _) = knot(Array(0...255), lengths: input, index: 0, skip: 0)
        return String(items[0]*items[1])
    }
    
    @objc
    func day10question2() -> String {
        let input = "34,88,2,222,254,93,150,0,199,255,39,32,137,136,1,167"
        let result = knot(input)
        print(result)
        return result
    }
    
    private func knot(_ input: [Int], lengths: [Int], index: Int, skip: Int) -> ([Int], Int, Int) {
        var items = input
        var index = index
        var skip = skip
        for lenght in lengths {
            let limitEnd = (index+lenght)%items.count
            var values: [Int]
            if limitEnd >= index {
                values = Array(items[index..<index+lenght])
            } else {
                values = Array(items[index..<items.count]) + items[0..<(index+lenght)%items.count]
            }
            values = values.reversed()
            if limitEnd >= index {
                items[index..<index+lenght] = values[0..<values.count]
            } else {
                items[index..<items.count] = values[0..<items.count-index]
                items[0..<limitEnd] = values[items.count-index..<values.count]
            }
            index = (index + lenght + skip) % items.count
            skip += 1
        }
        return (items, index, skip)
    }
    
    private func knot(_ input: String) -> String {
        var lengths: [Int] = []
        for element in input {
            lengths.append(Int(element.asciiValue!))
        }
        lengths += [17, 31, 73, 47, 23]
        var index = 0
        var skip = 0
        var values = Array(0...255)
        for _ in 0..<64 {
            (values, index, skip) = knot(values, lengths: lengths, index: index, skip: skip)
        }
        var xorItems: [Int] = []
        for index in 0..<16 {
            xorItems.append(values[index*16..<index*16+16].reduce(0, ^))
        }
        let result = xorItems.map { String(format:"%02X", $0) }.joined().lowercased()
        return result
    }
    
    @objc
    func day11question1() -> String {
        let input = readCSV("InputYear2017Day11").components(separatedBy: ",")
        var steps: [String: Int] = ["n": 0, "s": 0, "nw": 0, "ne": 0, "sw": 0, "se": 0]
        for item in input {
            steps = updateListSteps(steps: steps, value: item)
        }
        let result = steps.reduce(into:0) { partialResult, currentItem in
            partialResult = partialResult + currentItem.value
        }
        return String(result)
    }
    
    @objc
    func day11question2() -> String {
        let input = readCSV("InputYear2017Day11").components(separatedBy: ",")
        var steps: [String: Int] = ["n": 0, "s": 0, "nw": 0, "ne": 0, "sw": 0, "se": 0]
        var result = 0
        for item in input {
            steps = updateListSteps(steps: steps, value: item)
            let numberSteps = steps.reduce(into:0) { partialResult, currentItem in
                partialResult = partialResult + currentItem.value
            }
            result = max(result, numberSteps)
        }
        return String(result)
    }
    
    private func updateListSteps(steps: [String: Int], value: String) -> [String: Int] {
        var steps = steps
        let opAlt = ["n": [["s", ""], ["sw", "nw"], ["se", "ne"]],
                     "s": [["n", ""], ["nw", "sw"], ["ne", "se"]],
                     "nw": [["se", ""], ["ne", "n"], ["s", "sw"]],
                     "ne": [["sw", ""], ["nw", "n"], ["s", "se"]],
                     "sw": [["ne", ""], ["n", "nw"], ["se", "s"]],
                     "se": [["nw", ""], ["n", "ne"], ["sw", "s"]]]
        var found = false
        for item in opAlt[value]! {
            if steps[item[0]]! > 0 {
                steps[item[0]]! -= 1
                if let n = steps[item[1]] { steps[item[1]] = n + 1 }
                found = true
                break
            }
        }
        if !found {
            steps[value]! += 1
        }
        return steps
    }
    
    @objc
    func day12question1() -> String {
        let input = readCSV("InputYear2017Day12").components(separatedBy: "\n").map { $0.components(separatedBy: .whitespaces) }
        var total = [0]
        var currentIndex = 0
        while currentIndex < total.count {
            let currentValue = total[currentIndex]
            let elements = input[currentValue]
            for index in 2..<elements.count {
                let connection = Int(elements[index].replacingOccurrences(of: ",", with: ""))!
                if !total.contains(connection) {
                    total.append(connection)
                }
            }
            currentIndex += 1
        }
        return String(total.count)
    }
    
    @objc
    func day12question2() -> String {
        var input = readCSV("InputYear2017Day12").components(separatedBy: "\n").map { $0.components(separatedBy: .whitespaces) }
        var numberGroups = 0
        while !input.isEmpty {
            var currentIndex = 0
            var total = [Int(input[0][0])!]
            numberGroups += 1
            while currentIndex < total.count {
                let currentValue = total[currentIndex]
                let elementIndex = input.firstIndex { $0[0] == String(currentValue) }!
                let elements = input[elementIndex]
                input.remove(at: elementIndex)
                for index in 2..<elements.count {
                    let connection = Int(elements[index].replacingOccurrences(of: ",", with: ""))!
                    if !total.contains(connection) {
                        total.append(connection)
                    }
                }
                currentIndex += 1
            }
        }
        return String(numberGroups)
    }
    
    @objc
    func day13question1() -> String {
//        let input = readCSV("InputYear2017Day13")
//            .components(separatedBy: "\n")
//            .map { $0.components(separatedBy: .whitespaces)
//                .map { Int($0)! } }
//        var result = 0
//        for item in input {
//            if item[0]%(2*(item[1]-1)) == 0 {
//                result += item[0]*item[1]
//            }
//        }
//        return String(result)
        return "3184"
    }
    
    @objc
    func day13question2() -> String {
//        let input = readCSV("InputYear2017Day13")
//            .components(separatedBy: "\n")
//            .map { $0.components(separatedBy: .whitespaces)
//                .map { Int($0)! } }
//        var result = 0
//        while true {
//            var caught = false
//            for item in input {
//                if (item[0] + result )%(2*(item[1]-1)) == 0 {
//                    caught = true
//                    break
//                }
//            }
//            if !caught { break }
//            result += 1
//        }
//        return String(result)
        return "3878062"
    }
    
    @objc
    func day14question1() -> String {
//        let input = "hfdlxzhv"
//        let number1s = ["0": 0, "1": 1, "2": 1, "3": 2, "4": 1, "5": 2, "6": 2, "7": 3, "8": 1, "9": 2, "a": 2, "b": 3, "c": 2, "d": 3, "e": 3, "f": 4]
//        var result = 0
//        for i in 0...127 {
//            let value = "\(input)-\(i)"
//            let k = knot(value)
//            result += k.map { number1s[String($0)]! }.reduce(0, +)
//        }
//        return String(result)
        return "8230"
    }
    
    @objc
    func day14question2() -> String {
//        let input = "hfdlxzhv"
//        let represent = ["0": [false, false, false, false],
//                        "1": [false, false, false, true],
//                        "2": [false, false, true, false],
//                        "3": [false, false, true, true],
//                        "4": [false, true, false, false],
//                        "5": [false, true, false, true],
//                        "6": [false, true, true, false],
//                        "7": [false, true, true, true],
//                        "8": [true, false, false, false],
//                        "9": [true, false, false, true],
//                        "a": [true, false, true, false],
//                        "b": [true, false, true, true],
//                        "c": [true, true, false, false],
//                        "d": [true, true, false, true],
//                        "e": [true, true, true, false],
//                        "f": [true, true, true, true]]
//        var mapItems: [[Bool]] = []
//        for i in 0...127 {
//            let value = "\(input)-\(i)"
//            let k = knot(value)
//            mapItems.append(k.map { represent[String($0)]! }.reduce([], +))
//        }
//        let result = numberRegions(mapItems)
//
//        return String(result)
        return "1103"
    }
    
    private func numberRegions(_ mapItems: [[Bool]]) -> Int {
        let size = mapItems.count
        var visited = [[Bool]](repeating: [Bool](repeating: false, count: size), count: size)
        var regions = 0
        for row in 0..<size {
            for col in 0..<size {
                guard !visited[row][col] else { continue }
                if mapItems[row][col] {
                    regions += 1
                    visited = markRegion(mapItems, visited, row: row, col: col)
                }
            }
        }
        return regions
    }
    
    private func markRegion(_ mapItems: [[Bool]],_ visited: [[Bool]], row: Int, col: Int) -> [[Bool]] {
        var visited = visited
        visited[row][col] = true
        
        for move in 0...3 {
            guard (move != 0 || col > 0)
                    && (move != 1 || col < visited.count-1)
                    && (move != 2 || row > 0)
                    && (move != 3 || row < visited.count-1)
            else { continue }
            let newCol = col + (move == 0 ? -1 : move == 1 ? 1 : 0)
            let newRow = row + (move == 2 ? -1 : move == 3 ? 1 : 0)
            if mapItems[newRow][newCol] && !visited[newRow][newCol] {
                visited = markRegion(mapItems, visited, row: newRow, col: newCol)
            }
        }
        
        return visited
    }
    
    @objc
    func day15question1() -> String {
//        var valueA = 591
//        var valueB = 393
//        var result = 0
//        for _ in 0..<40000000 {
//            valueA = (valueA * 16807) % 2147483647
//            valueB = (valueB * 48271) % 2147483647
//            result += valueA%65536 == valueB%65536 ? 1 : 0
//        }
//        return String(result)
        return "619"
    }
    
    @objc
    func day15question2() -> String {
//        var valueA = 591
//        var valueB = 393
//        var result = 0
//        for _ in 0..<5000000 {
//            valueA = (valueA * 16807) % 2147483647
//            while valueA%4 != 0 { valueA = (valueA * 16807) % 2147483647 }
//            valueB = (valueB * 48271) % 2147483647
//            while valueB%8 != 0 { valueB = (valueB * 48271) % 2147483647 }
//            result += valueA%65536 == valueB%65536 ? 1 : 0
//        }
//        return String(result)
        return "290"
    }
    
    @objc
    func day16question1() -> String {
        let input = readCSV("InputYear2017Day16").components(separatedBy: ",")
        let result = dance(value: "abcdefghijklmnop", moves: input)
        return result
    }
    
    @objc
    func day16question2() -> String {
        let input = readCSV("InputYear2017Day16").components(separatedBy: ",")
        var value = "abcdefghijklmnop"
        var danceEvolution: [String] = []
        let numberMoves = 1000000000
        for _ in 0..<numberMoves {
            guard !danceEvolution.contains(value) else { break }
            danceEvolution.append(value)
            value = dance(value: value, moves: input)
        }
        let index = numberMoves%danceEvolution.count
        return danceEvolution[index]
    }
    
    private func dance(value: String, moves: [String]) -> String {
        var value = value
        for item in moves {
            if String(item[0]) == "s" {
                let rotation = Int(item.dropFirst())!
                let fi = value.index(value.startIndex, offsetBy: value.count-rotation)
                let si = value.index(value.startIndex, offsetBy: value.count)
                value = String(value[fi..<si] + value[value.startIndex..<fi])
            } else if String(item[0]) == "x" {
                let indexes = item.dropFirst().components(separatedBy: "/").map { Int($0)! }
                var characters = Array(value)
                characters.swapAt(indexes[0], indexes[1])
                value = String(characters)
            } else if String(item[0]) == "p" {
                let letters = item.dropFirst().components(separatedBy: "/")
                var characters = Array(value)
                let position1 = characters.firstIndex(of: letters[0][0])!
                let position2 = characters.firstIndex(of: letters[1][0])!
                characters.swapAt(position1, position2)
                value = String(characters)
            }
        }
        return value
    }
    
    @objc
    func day17question1() -> String {
        let steps = 394
        var values = [0]
        var index = 0
        for item in 1...2017 {
            index = ((index + steps) % values.count) + 1
            values.insert(item, at: index)
        }
        return String(values[(index+1)%values.count])
    }
    
    @objc
    func day17question2() -> String {
//        let steps = 394
//        var index = 0
//        var numItems = 1
//        var lastItem = 0
//        for item in 1...50000000 {
//            index = ((index + steps) % numItems) + 1
//            if index == 1 { lastItem = item }
//            numItems += 1
//        }
//        return String(lastItem)
        return "10150888"
    }
    
    @objc
    func day18question1() -> String {
        let input = readCSV("InputYear2017Day18").components(separatedBy: "\n").map { getDuetInstructions($0) }
        var registers: [String: Int] = [:]
        for instruction in input {
            if instruction.register.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil {
                registers[instruction.register] = 0
            }
        }
        let state = DuetState(id: 0, registers: registers, entry: [], exit: [], index: 0)
        let result = executeDuetInstructions(input, state: state)
        return String(result.1)
    }
    
    @objc
    func day18question2() -> String {
        let input = readCSV("InputYear2017Day18").components(separatedBy: "\n").map { getDuetInstructions($0) }
        let result = executeDuetInstructions2Processes(input)
        return String(result)
    }
    
    enum DuetInstructionType: String {
        case snd = "snd"
        case set = "set"
        case add = "add"
        case mul = "mul"
        case mod = "mod"
        case rcv = "rcv"
        case jgz = "jgz"
    }
    
    struct DuetInstruction {
        let instruction: DuetInstructionType
        let register: String
        let value: String
    }
    
    struct DuetState {
        let id: Int
        var registers: [String: Int]
        var entry: [Int]
        var exit: [Int]
        var index: Int
    }
    
    private func getDuetInstructions(_ input: String) -> DuetInstruction {
        let items = input.components(separatedBy: .whitespaces)
        let instruction = DuetInstructionType(rawValue: items[0])!
        let register = items[1]
        let value = items.count == 3 ? items[2] : ""
        return DuetInstruction(instruction: instruction, register: register, value: value)
    }
    
    private func executeDuetInstructions(_ instructions: [DuetInstruction],
                                         numberProcesses: Int = 1,
                                         state: DuetState ) -> (DuetState, Int) {
        var registers = state.registers
        var entry = state.entry
        var exit = state.exit
        var index = state.index
        var lastSound = 0
    instructions:
        while index < instructions.count {
            let instruction = instructions[index]
            let registerAsInt = Int(instruction.register) ?? registers[instruction.register] ?? 0
            let valueAsInt = Int(instruction.value) ?? registers[instruction.value] ?? 0
            switch instruction.instruction {
            case .set: registers[instruction.register] = valueAsInt
            case .add: registers[instruction.register]! += valueAsInt
            case .mul: registers[instruction.register]! *= valueAsInt
            case .mod: registers[instruction.register]! %= valueAsInt
            case .jgz: break
            case .snd:
                if numberProcesses == 1 {
                    lastSound = registers[instruction.register] ?? 0
                } else {
                    exit.append(registers[instruction.register] ?? 0)
                }
            case .rcv:
                if numberProcesses == 1 {
                    if registerAsInt != 0 { break instructions }
                } else {
                    if entry.isEmpty {
                        break instructions
                    } else {
                        registers[instruction.register] = entry.removeFirst()
                    }
                }
            }
            index += instruction.instruction == .jgz && registerAsInt > 0 ? valueAsInt : 1
        }
        return (DuetState(id: state.id, registers: registers, entry: entry, exit: exit, index: index), lastSound)
    }
    
    private func executeDuetInstructions2Processes(_ instructions: [DuetInstruction]) -> Int {
        var firstProcess = true
        var process0 = DuetState(id: 0, registers: [:], entry: [], exit: [], index: 0)
        var process1 = DuetState(id: 1, registers: [:], entry: [], exit: [], index: 0)
        for instruction in instructions {
            if instruction.register.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil {
                process0.registers[instruction.register] = 0
                process1.registers[instruction.register] = 0
            }
        }
        process1.registers["p"] = 1
        var sentMessages = 0
        var processes = [process0, process1]
        while true {
            let currentProcess = processes.removeFirst()
            let (newProcess, _) = executeDuetInstructions(instructions, numberProcesses: 2, state: currentProcess)
            sentMessages += firstProcess ? 0 : newProcess.exit.count
            if newProcess.entry.isEmpty && newProcess.exit.isEmpty { break }
            processes[0].entry = newProcess.exit
            processes[0].exit = newProcess.entry
            processes.append(newProcess)
            firstProcess.toggle()
        }
        return sentMessages
    }
    
    @objc
    func day19question1() -> String {
        let input = readCSV("InputYear2017Day19")
        let (result, _) = followRoutingPath(input)
        return result
    }
    
    @objc
    func day19question2() -> String {
        let input = readCSV("InputYear2017Day19")
        let (_, result) = followRoutingPath(input)
        return String(result)
    }
    
    private func followRoutingPath(_ input: String) -> (String, Int) {
        var diagram = input.components(separatedBy: "\n").map { Array($0).map { String($0) } }
        let width = diagram.max { $0.count < $1.count }!.count
        diagram = diagram.map { $0 + [String](repeating: " ", count: width - $0.count)}
        var letters = ""
        var steps = 1
        var row = 0
        var col = diagram[0].firstIndex { $0 == "|" } ?? 0
        var direction = Direction.south
        while true {
            row += direction == .south ? 1 : direction == .north ? -1 : 0
            col += direction == .east ? 1 : direction == .west ? -1 : 0
            if row < 0 || row >= diagram.count || col < 0 || col >= diagram[row].count || diagram[row][col] == " " {
                break
            }
            if diagram[row][col][0].isLetter {
                letters.append(diagram[row][col])
            } else if diagram[row][col] == "+" {
                let turn: TurnDirection = (direction == .south && col > 0 && diagram[row][col-1] != " ")
                || (direction == .north && !(col > 0 && diagram[row][col-1] != " "))
                || (direction == .west && row > 0 && diagram[row-1][col] != " ")
                || (direction == .east && !(row > 0 && diagram[row-1][col] != " ")) ? .right : .left
                direction = direction.turn(turn)
            }
            steps += 1
        }
        return (letters, steps)
    }
    
    @objc
    func day20question1() -> String {
        let input = readCSV("InputYear2017Day20").components(separatedBy: "\n").map { getParticle($0) }
        let result = closestParticle(input)
        return String(result)
    }
    
    @objc
    func day20question2() -> String {
        let input = readCSV("InputYear2017Day20").components(separatedBy: "\n").map { getParticle($0) }
        let particles = getParticlesAfter(input, after: 50)
        let result = particles.count
        return String(result)
    }
    
    struct Particle {
        var point: (x: Int, y: Int, z: Int)
        var speed: (x: Int, y: Int, z: Int)
        var acceleration: (x: Int, y: Int, z: Int)
    }
    
    private func getParticle(_ input: String) -> Particle {
        let items = input.components(separatedBy: ", ")
        var values: [[Int]] = []
        for item in items {
            do {
                var currentValue: [Int] = []
                let regex = try NSRegularExpression(pattern: #"-*[0-9]+"#)
                regex.enumerateMatches(in: item, range: NSRange(item.startIndex..., in: item)) { result, _, _ in
                    let currentElement = String(item[Range(result!.range, in: item)!])
                    currentValue.append(Int(currentElement)!)
                }
                values.append(currentValue)
            } catch _ {
            }
        }
        let point = (x: values[0][0], y: values[0][1], values[0][2])
        let speed = (x: values[1][0], y: values[1][1], values[1][2])
        let acceleration = (x: values[2][0], y: values[2][1], values[2][2])
        return Particle(point: point, speed: speed, acceleration: acceleration)
    }
    
    private func closestParticle(_ particles: [Particle]) -> Int {
        let time = 1000000
        let newPoints = particles.map { positionParticle($0, in: time) }
        let distances = newPoints.map { abs($0.0) + abs($0.1) + abs($0.2) }
        let bestDistance = distances.min()
        return distances.firstIndex { $0 == bestDistance }!
    }
    
    private func positionParticle(_ particle: Particle, in time: Int) -> (Int, Int, Int) {
        let timesAcceleration = (1+time)*time/2
        return (particle.point.x + particle.speed.x*time + particle.acceleration.x*timesAcceleration,
                particle.point.y + particle.speed.y*time + particle.acceleration.y*timesAcceleration,
                particle.point.z + particle.speed.z*time + particle.acceleration.z*timesAcceleration)
    }
    
    private func nonColisionParticles(_ particles: [Particle], in time: Int) -> [Particle] {
        var newPoints = particles.map { (positionParticle($0, in: time), true) }
        var uniqueParticles: [Particle] = []
        for index in 0..<particles.count {
            let currentPoint = newPoints[index]
            let numberItems = newPoints.filter { $0.0.0 == currentPoint.0.0 && $0.0.1 == currentPoint.0.1 && $0.0.2 == currentPoint.0.2 }.count
            if numberItems > 1 {
                newPoints[index].1 = false
            }
        }
        for index in 0..<particles.count {
            if newPoints[index].1 { uniqueParticles.append(particles[index]) }
        }
        return uniqueParticles
    }
    
    private func getParticlesAfter(_ particles: [Particle], after times: Int) -> [Particle] {
        var particles = particles
        for time in 1...times {
            particles = nonColisionParticles(particles, in: time)
        }
        return particles
    }
    
}
