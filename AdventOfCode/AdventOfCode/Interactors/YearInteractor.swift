//
//  YearInteractor.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 20/12/21.
//

import Foundation

protocol YearInteractor: NSObject {
    
    func calculate(day: Int, question: Int) -> String
    
}

extension YearInteractor {
    
    func calculate(day: Int, question: Int) -> String {
        let method = "day\(day)question\(question)"
        guard let result = perform(Selector(method)).takeUnretainedValue() as? String else {
            return "Error"
        }
        return result
    }
    
    func readCSV(_ name: String) -> String {
        guard let filepath = Bundle.main.path(forResource: name, ofType: "csv") else { return "" }
        do {
            let contents = try String(contentsOfFile: filepath, encoding: .utf8)
            return contents
        }
        catch {
            return ""
        }
    }
    
}
