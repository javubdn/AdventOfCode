//
//  Year2022InteractorImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 22/12/22.
//

import Foundation

class Year2022InteractorImpl: NSObject {
    
}

extension Year2022InteractorImpl: YearInteractor {
    
    @objc
    func day1question1() -> String {
        "\(readCSV("InputYear2022Day1").components(separatedBy: "\n\n").map { $0.components(separatedBy: .newlines).map { Int($0)! }.reduce(0, +) }.max()!)"
    }
    
    @objc
    func day1question2() -> String {
        let values = readCSV("InputYear2022Day1").components(separatedBy: "\n\n").map { $0.components(separatedBy: .newlines).map { Int($0)! }.reduce(0, +) }.sorted { $0 > $1 }
        return "\(values[0] + values[1] + values[2])"
    }
    
    @objc
    func day2question1() -> String {
        "\(readCSV("InputYear2022Day2").components(separatedBy: .newlines).map { getScoreRPS($0) }.reduce(0, +))"
    }
    
    @objc
    func day2question2() -> String {
        "\(readCSV("InputYear2022Day2").components(separatedBy: .newlines).map { getScoreRPS2($0) }.reduce(0, +))"
    }
    
    private func getScoreRPS(_ input: String) -> Int {
        let elements = input.components(separatedBy: .whitespaces)
        let oponent = elements[0] == "A" ? 1 : elements[0] == "B" ? 2 : 3
        let mine = elements[1] == "X" ? 1 : elements[1] == "Y" ? 2 : 3
        let result = (mine - oponent + 3) % 3
        return mine + (result == 0 ? 3 : result == 1 ? 6 : 0)
    }
    
    private func getScoreRPS2(_ input: String) -> Int {
        let elements = input.components(separatedBy: .whitespaces)
        let oponent = elements[0] == "A" ? 1 : elements[0] == "B" ? 2 : 3
        let expected = elements[1] == "X" ? 0 : elements[1] == "Y" ? 3 : 6
        let mine = expected == 3 ? oponent : expected == 0 ? (oponent % 3) + 2 - (oponent == 2 ? 3 : 0) : (oponent % 3) + 1
        return expected + mine
    }
    
    @objc
    func day3question1() -> String {
        let input = readCSV("InputYear2022Day3").components(separatedBy: .newlines)
        let result = input.map { getPriorityObject($0) }.reduce(0, +)
        return "\(result)"
    }
    
    @objc
    func day3question2() -> String {
        let input = readCSV("InputYear2022Day3").components(separatedBy: .newlines)
        let result = input.chunked(into: 3).map { getPriorityGroup($0) }.reduce(0, +)
        return "\(result)"
    }
    
    private func getPriorityObject(_ input: String) -> Int {
        let values = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let (first, second) = input.splitInHalf()
        let item = first.first { second.contains($0) }!
        let result = values.distance(from: values.startIndex, to: values.firstIndex(of: item)!) + 1
        return result
    }
    
    private func getPriorityGroup(_ input: [String]) -> Int {
        let values = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let item = input[0].first { input[1].contains($0) && input[2].contains($0) }!
        let result = values.distance(from: values.startIndex, to: values.firstIndex(of: item)!) + 1
        return result
    }
    
    @objc
    func day4question1() -> String {
        let input = readCSV("InputYear2022Day4")
            .components(separatedBy: .newlines)
            .map { $0.components(separatedBy: ",")
                .map { $0.components(separatedBy: "-")
                    .map { Int($0)! } } }
        let result = input.filter { ($0[0][0] <= $0[1][0] && $0[0][1] >= $0[1][1]) || ($0[0][0] >= $0[1][0] && $0[0][1] <= $0[1][1]) }.count
        return "\(result)"
    }
    
    @objc
    func day4question2() -> String {
        let input = readCSV("InputYear2022Day4")
            .components(separatedBy: .newlines)
            .map { $0.components(separatedBy: ",")
                .map { $0.components(separatedBy: "-")
                    .map { Int($0)! } } }
        let result = input.filter { $0[0][1] >= $0[1][0] && $0[0][0] <= $0[1][1] }.count
        return "\(result)"
    }
    
    @objc
    func day5question1() -> String {
        executeDay5(true)
    }
    
    @objc
    func day5question2() -> String {
        executeDay5(false)
    }
    
    private struct MoveStack {
        let move: Int
        let from: Int
        let to: Int
    }
    
    private func getDistribution(_ input: String) -> ([Stack<String>], [MoveStack]) {
        let elements = input.components(separatedBy: "\n\n")
        var valuesStack = elements[0].components(separatedBy: .newlines)
        let stackNumber = Int(String(valuesStack.removeLast().replacingOccurrences(of: " ", with: "").last!))!
        var stacks = [Stack<String>](repeating: Stack<String>(), count: stackNumber)
        while !valuesStack.isEmpty {
            let items = valuesStack.removeLast()
            for index in 1...stackNumber {
                let position = (index-1)*4+1
                if items[position] != " " {
                    stacks[index-1].push(String(items[position]))
                }
            }
        }
        let moveStacks = elements[1].components(separatedBy: .newlines).map { element in
            let items = element.components(separatedBy: .whitespaces)
            return MoveStack(move: Int(items[1])!, from: Int(items[3])!, to: Int(items[5])!)
        }
        return (stacks, moveStacks)
    }
    
    private func executeDay5(_ reversed: Bool) -> String {
        let input = readCSV("InputYear2022Day5")
        var (stacks, instructions) = getDistribution(input)
        for instruction in instructions {
            if let values = stacks[instruction.from-1].pop(instruction.move) {
                stacks[instruction.to-1].push(reversed ? values.reversed() : values)
            }
        }
        let result = stacks.map { $0.peek() ?? " " }.joined()
        return "\(result)"
    }
    
    @objc
    func day6question1() -> String {
        executeDay6(4)
    }
    
    @objc
    func day6question2() -> String {
        executeDay6(14)
    }
    
    private func executeDay6(_ validation: Int) -> String {
        let input = readCSV("InputYear2022Day6")
        for index in validation-1..<input.count {
            let dict = input[(index-validation+1)...index].reduce([Character: Int]()) { partialResult, char in
                var p = partialResult
                p[char] = (p[char] ?? 0) + 1
                return p
            }
            if dict.count == validation {
                return "\(index+1)"
            }
        }
        return ""
    }
    
    @objc
    func day7question1() -> String {
        let input = readCSV("InputYear2022Day7").components(separatedBy: .newlines)
        let mainDirectory = getMainDirectory(input)
        let result = getSizesFromDirectories(mainDirectory)
        return "\(result)"
    }
    
    @objc
    func day7question2() -> String {
        let input = readCSV("InputYear2022Day7").components(separatedBy: .newlines)
        let mainDirectory = getMainDirectory(input)
        let needed = mainDirectory.size - 40_000_000
        let result = minimumDirectorySize(mainDirectory, needed).0
        return "\(result)"
    }
    
    private func getSizesFromDirectories(_ directory: Directory) -> Int {
        var sum = 0
        for item in directory.children {
            guard let d = item as? Directory else { continue }
            sum += getSizesFromDirectories(d)
        }
        return sum + (directory.size <= 100000 ? directory.size : 0)
    }
    
    private func minimumDirectorySize(_ directory: Directory, _ minimumSize: Int) -> (Int, Bool) {
        var minimum = Int.max
        var validChildren = false
        for item in directory.children {
            guard let d = item as? Directory else { continue }
            let (size, valid) = minimumDirectorySize(d, minimumSize)
            guard valid else { continue }
            validChildren = true
            minimum = min(minimum, size)
        }
        let bestValue = validChildren ? minimum : directory.size
        return (bestValue, bestValue >= minimumSize)
    }
    
    private func getMainDirectory(_ input: [String]) -> Directory {
        var mainDirectory: Directory!
        var currentDirectory: Directory? = nil
        input.forEach { item in
            let elements = item.components(separatedBy: .whitespaces)
            if elements[0] == "$" {
                guard elements[1] == "cd" else { return }
                switch elements[2] {
                case "/":
                    mainDirectory = Directory("/")
                    currentDirectory = mainDirectory
                case "..": currentDirectory = currentDirectory?.parent
                default:
                    let directory = currentDirectory?.children.first { item in
                        guard let directory = item as? Directory else { return false }
                        return directory.name == elements[2]
                    }
                    currentDirectory = directory as? Directory
                }
            } else {
                let newItem: DirectoryTree = elements[0] == "dir" ? Directory(elements[1]) : File(elements[1], Int(elements[0])!)
                newItem.setParent(currentDirectory)
                currentDirectory?.add(newItem)
            }
        }
        return mainDirectory
    }
    
    @objc
    func day8question1() -> String {
        let input = readCSV("InputYear2022Day8").components(separatedBy: .newlines).map { $0.map { Int(String($0))! } }
        var visibles = [[(Bool, Bool, Bool, Bool)]](repeating: [(Bool, Bool, Bool, Bool)](repeating: (true, true, true, true),
                                                                                          count: input[0].count),
                                                    count: input.count)
        var topHidden = input.first!
        var bottomHidden = input.last!
        var leftHidden = input.map { $0.first! }
        var rightHidden = input.map { $0.last! }
        for i in 1..<input.count-1 {
            for j in 1..<input[0].count {
                let minor = input[i][j] <= topHidden[j]
                visibles[i][j].0 = !minor
                topHidden[j] = minor ? topHidden[j] : input[i][j]
            }
        }
        for i in stride(from: input.count-2, through: 1, by: -1) {
            for j in 1..<input[0].count {
                if input[i][j] <= bottomHidden[j] {
                    visibles[i][j].1 = false
                } else {
                    bottomHidden[j] = input[i][j]
                }
            }
        }
        for j in 1..<input[0].count-1 {
            for i in 1..<input.count {
                if input[i][j] <= leftHidden[i] {
                    visibles[i][j].2 = false
                } else {
                    leftHidden[i] = input[i][j]
                }
            }
        }
        for j in stride(from: input[0].count-2, through: 1, by: -1) {
            for i in 1..<input.count {
                if input[i][j] <= rightHidden[i] {
                    visibles[i][j].3 = false
                } else {
                    rightHidden[i] = input[i][j]
                }
            }
        }
        let result = visibles.map { $0.filter { $0.0 || $0.1 || $0.2 || $0.3 }.count }.reduce(0, +)
        return "\(result)"
    }
    
    
}
