//
//  Year2019InteractorImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 10/5/22.
//

import Foundation

class Year2019InteractorImpl: NSObject {
}

extension Year2019InteractorImpl: YearInteractor {
    
    @objc
    func day1question1() -> String {
        let input = readCSV("InputYear2019Day1").components(separatedBy: .newlines).map { Int($0)! }
        let result = input.map { $0/3 - 2 }.reduce(0, +)
        return String(result)
    }
    
    @objc
    func day1question2() -> String {
        let input = readCSV("InputYear2019Day1").components(separatedBy: .newlines).map { Int($0)! }
        let result = input.map { calculateFuel($0) }.reduce(0, +)
        return String(result)
    }
    
    func calculateFuel(_ mass: Int) -> Int {
        let fuel = mass/3 - 2
        if fuel <= 0 { return 0 }
        return fuel + calculateFuel(fuel)
    }
    
}
