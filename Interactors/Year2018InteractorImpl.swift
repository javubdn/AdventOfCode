//
//  Year2018InteractorImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 10/3/22.
//

import Foundation

class Year2018InteractorImpl: NSObject {
}

extension Year2018InteractorImpl: YearInteractor {
    
    @objc
    func day1question1() -> String {
        let input = readCSV("InputYear2018Day1").components(separatedBy: .newlines).map { Int($0)! }
        let result = input.reduce(0, +)
        return String(result)
    }
    
    @objc
    func day1question2() -> String {
        let input = readCSV("InputYear2018Day1").components(separatedBy: .newlines).map { Int($0)! }
        var repeated: Set<Int> = [0]
        var sum = 0
        var index = 0
        while true {
            sum += input[index]
            if repeated.contains(sum) { break }
            repeated.insert(sum)
            index = (index + 1) % input.count
        }
        return String(sum)
    }
    
    @objc
    func day2question1() -> String {
        let input = readCSV("InputYear2018Day2").components(separatedBy: .newlines)
        var counts2 = 0
        var counts3 = 0
        for item in input {
            let counts = Utils.countChars(item)
            if counts.first(where: { $0.value == 2 }) != nil { counts2 += 1 }
            if counts.first(where: { $0.value == 3 }) != nil { counts3 += 1 }
        }
        return String(counts2 * counts3)
    }
    
    @objc
    func day2question2() -> String {
        let input = readCSV("InputYear2018Day2").components(separatedBy: .newlines)
        for item in input {
            if let item2 = input.first(where: { $0 != item && differentStringBy1($0, item) }) {
                let result = commonString(item, item2)
                print(result)
                return result
            }
        }
        return ""
    }
    
    private func differentStringBy1(_ value1: String, _ value2: String) -> Bool {
        var differences = 0
        for index in 0..<value1.count {
            if value1[index] != value2[index] { differences += 1 }
            if differences > 1 { return false }
        }
        return true
    }
    
    private func commonString(_ value1: String, _ value2: String) -> String {
        var common = ""
        for index in 0..<value1.count {
            if value1[index] == value2[index] { common.append(value1[index]) }
        }
        return common
    }
    
}
