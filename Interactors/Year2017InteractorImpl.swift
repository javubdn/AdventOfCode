//
//  Year2017InteractorImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 17/2/22.
//

import Foundation

class Year2017InteractorImpl: NSObject {
    
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
    
    @objc
    func day11question1() -> String {
        let input = readCSV("InputYear2017Day11").components(separatedBy: ",")
        var steps: [String] = []
        for item in input {
            switch item {
            case "n":
                if let index = steps.firstIndex(where: { $0 == "s" }) {
                    steps.remove(at: index)
                } else if let index = steps.firstIndex(where: { $0 == "sw" }) {
                    steps.remove(at: index)
                    steps.append("nw")
                } else if let index = steps.firstIndex(where: { $0 == "se" }) {
                    steps.remove(at: index)
                    steps.append("ne")
                } else {
                    steps.append("n")
                }
            case "nw":
                if let index = steps.firstIndex(where: { $0 == "se" }) {
                    steps.remove(at: index)
                } else if let index = steps.firstIndex(where: { $0 == "ne" }) {
                    steps.remove(at: index)
                    steps.append("n")
                } else if let index = steps.firstIndex(where: { $0 == "s" }) {
                    steps.remove(at: index)
                    steps.append("sw")
                } else {
                    steps.append("nw")
                }
            case "ne":
                if let index = steps.firstIndex(where: { $0 == "sw" }) {
                    steps.remove(at: index)
                } else if let index = steps.firstIndex(where: { $0 == "nw" }) {
                    steps.remove(at: index)
                    steps.append("n")
                } else if let index = steps.firstIndex(where: { $0 == "s" }) {
                    steps.remove(at: index)
                    steps.append("se")
                } else {
                    steps.append("ne")
                }
            case "s":
                if let index = steps.firstIndex(where: { $0 == "n" }) {
                    steps.remove(at: index)
                } else if let index = steps.firstIndex(where: { $0 == "nw" }) {
                    steps.remove(at: index)
                    steps.append("sw")
                } else if let index = steps.firstIndex(where: { $0 == "ne" }) {
                    steps.remove(at: index)
                    steps.append("se")
                } else {
                    steps.append("s")
                }
            case "sw":
                if let index = steps.firstIndex(where: { $0 == "ne" }) {
                    steps.remove(at: index)
                } else if let index = steps.firstIndex(where: { $0 == "n" }) {
                    steps.remove(at: index)
                    steps.append("nw")
                } else if let index = steps.firstIndex(where: { $0 == "se" }) {
                    steps.remove(at: index)
                    steps.append("s")
                } else {
                    steps.append("sw")
                }
            case "se":
                if let index = steps.firstIndex(where: { $0 == "nw" }) {
                    steps.remove(at: index)
                } else if let index = steps.firstIndex(where: { $0 == "n" }) {
                    steps.remove(at: index)
                    steps.append("ne")
                } else if let index = steps.firstIndex(where: { $0 == "sw" }) {
                    steps.remove(at: index)
                    steps.append("s")
                } else {
                    steps.append("se")
                }
            default: break
            }
        }
        let result = steps.count
        return String(result)
    }
    
    @objc
    func day11question2() -> String {
        return ""
    }
    
}
