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
    
}
