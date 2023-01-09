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
    
    
}
