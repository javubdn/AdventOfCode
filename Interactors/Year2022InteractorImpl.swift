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
    
    
}
