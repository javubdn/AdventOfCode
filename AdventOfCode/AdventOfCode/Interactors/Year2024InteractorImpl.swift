//
//  Year2024InteractorImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 13/11/2026.
//

import Foundation

class Year2024InteractorImpl: NSObject {
        
}

extension Year2024InteractorImpl: YearInteractor {
    
    @objc
    func day1question1() -> String {
        let elements = readCSV("InputYear2024Day1").components(separatedBy: "\n").map { item in
            item.split(separator: " ")
        }
        let first = elements.map { Int($0[0])! }.sorted()
        let second = elements.map { Int($0[1])! }.sorted()
        
        let result = zip(second, first).map { abs( $1 - $0 ) }.reduce(0, +)
        
        return "\(result)"
    }
    
    @objc
    func day1question2() -> String {
        let elements = readCSV("InputYear2024Day1").components(separatedBy: "\n").map { item in
            item.split(separator: " ")
        }
        let first = elements.map { Int($0[0])! }
        let second = elements.map { Int($0[1])! }.sorted()
        let conteo = Dictionary(second.map { ($0, 1) }, uniquingKeysWith: +)
        let result = first.map { $0 * (conteo[$0] ?? 0) }.reduce(0, +)
        return "\(result)"
    }
    
}
