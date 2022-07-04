//
//  Year2020InteractorImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 28/6/22.
//

import Foundation

class Year2020InteractorImpl: NSObject {
}

extension Year2020InteractorImpl: YearInteractor {
    
    @objc
    func day1question1() -> String {
        let input = readCSV("InputYear2020Day1").components(separatedBy: .newlines).map { Int($0)! }
        let result = Utils.cartesianProduct(lhs: input, rhs: input).first { $0.0 + $0.1 == 2020 }!
        return "\(result.0 * result.1)"
    }
    
    @objc
    func day1question2() -> String {
        let input = readCSV("InputYear2020Day1").components(separatedBy: .newlines).map { Int($0)! }
        let result = Utils.cartesianProduct(lhs: Utils.cartesianProduct(lhs: input, rhs: input), rhs: input)  .first { $0.0.0 + $0.0.1 + $0.1 == 2020 }!
        return "\(result.0.0 * result.0.1 * result.1)"
    }
    
    @objc
    func day2question1() -> String {
        let input = readCSV("InputYear2020Day2").components(separatedBy: .newlines).map { getPasswordPolicy($0) }
        let result = input.filter { isPasswordPolicyValid($0, oldMethod: true) }.count
        return "\(result)"
    }
    
    @objc
    func day2question2() -> String {
        let input = readCSV("InputYear2020Day2").components(separatedBy: .newlines).map { getPasswordPolicy($0) }
        let result = input.filter { isPasswordPolicyValid($0, oldMethod: false) }.count
        return "\(result)"
    }
    
    struct PasswordPolicy {
        let min: Int
        let max: Int
        let letter: Character
        let password: String
    }
    
    private func getPasswordPolicy(_ input: String) -> PasswordPolicy {
        let items = input.components(separatedBy: .whitespaces)
        let indexes = items[0].components(separatedBy: "-")
        return PasswordPolicy(min: Int(indexes[0])!, max: Int(indexes[1])!, letter: items[1][0], password: items[2])
    }
    
    private func isPasswordPolicyValid(_ passwordPolicy: PasswordPolicy, oldMethod: Bool) -> Bool {
        let occurrencies = passwordPolicy.password.filter { $0 == passwordPolicy.letter }.count
        if oldMethod {
            return occurrencies >= passwordPolicy.min && occurrencies <= passwordPolicy.max
        } else {
            let minChar = passwordPolicy.password[passwordPolicy.min-1]
            let maxChar = passwordPolicy.password[passwordPolicy.max-1]
            return (minChar == passwordPolicy.letter || maxChar == passwordPolicy.letter) &&
            !(minChar == passwordPolicy.letter && maxChar == passwordPolicy.letter)
        }
    }
    
    @objc
    func day3question1() -> String {
        let input = readCSV("InputYear2020Day3").components(separatedBy: .newlines).map { $0.map {  String($0) } }
        let result = getTrees(input, in: (3, 1))
        return "\(result)"
    }
    
    @objc
    func day3question2() -> String {
        let input = readCSV("InputYear2020Day3").components(separatedBy: .newlines).map { $0.map {  String($0) } }
        let slopes = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
        let result = slopes.map { getTrees(input, in: $0) }.reduce(1, *)
        
        return "\(result)"
    }
    
    private func getTrees(_ input: [[String]], in slope: (Int, Int)) -> Int {
        var trees = 0
        var row = 0
        var col = 0
        while row < input.count {
            trees += input[row][col] == "#" ? 1 : 0
            row += slope.1
            col = (col + slope.0) % input[0].count
        }
        return trees
    }
    
    @objc
    func day4question1() -> String {
        let input = readCSV("InputYear2020Day4").components(separatedBy: "\n\n")
        let result = input.filter { validPassport($0) }.count
        return "\(result)"
    }
    
    private func validPassport(_ input: String) -> Bool {
        let values = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
        let items = input.components(separatedBy: .newlines).joined(separator: " ").components(separatedBy: .whitespaces)
        return items.filter { values.contains($0.components(separatedBy: ":")[0]) }.count == 7
    }
    
}
