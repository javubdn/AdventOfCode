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
    
    @objc
    func day4question2() -> String {
        let input = readCSV("InputYear2020Day4").components(separatedBy: "\n\n")
        let result = input.filter { validPassportHD($0) }.count
        return "\(result)"
    }
    
    private func validPassport(_ input: String) -> Bool {
        let values = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
        let items = input.components(separatedBy: .newlines).joined(separator: " ").components(separatedBy: .whitespaces)
        return items.filter { values.contains($0.components(separatedBy: ":")[0]) }.count == 7
    }
    
    private func validPassportHD(_ input: String) -> Bool {
        guard validPassport(input) else { return false }
        let items = input.components(separatedBy: .newlines).joined(separator: " ").components(separatedBy: .whitespaces)
        for item in items {
            let fields = item.components(separatedBy: ":")
            let key = fields[0]
            let value = fields[1]
            switch key {
            case "byr":
                guard let year = Int(value) else { return false }
                if year < 1920 || year > 2002 { return false }
            case "iyr":
                guard let year = Int(value) else { return false }
                if year < 2010 || year > 2020 { return false }
            case "eyr":
                guard let year = Int(value) else { return false }
                if year < 2020 || year > 2030 { return false }
            case "hgt":
                if value.contains("cm") {
                    let height = Int(value.dropLast(2))!
                    if height < 150 || height > 193 { return false }
                } else if value.contains("in") {
                    let height = Int(value.dropLast(2))!
                    if height < 59 || height > 76 { return false }
                } else {
                    return false
                }
            case "hcl": if !value.starts(with: "#") || value.count != 7 { return false }
            case "ecl": if !["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(value) { return false }
            case "pid":
                guard let _ = Int(value) else { return false }
                if value.count != 9 { return false }
            default: break
            }
        }
        return true
    }
    
    @objc
    func day5question1() -> String {
        let input = readCSV("InputYear2020Day5").components(separatedBy: .newlines)
        let result = input.map { getIdBoardingPass($0) }.max()!
        return "\(result)"
    }
    
    @objc
    func day5question2() -> String {
        let input = readCSV("InputYear2020Day5").components(separatedBy: .newlines)
        let seats = input.map { getIdBoardingPass($0) }
        let result = (seats.min()!...seats.max()!).first { !seats.contains($0) }!
        return "\(result)"
    }
    
    private func getIdBoardingPass(_ input: String) -> Int {
        let numRow = input[0...6].enumerated().map { $0.element == "B" ? Int(pow(Double(2), Double(6 - $0.offset))) : 0 }.reduce(0, +)
        let numCol = input[8...10].enumerated().map { $0.element == "R" ? Int(pow(Double(2), Double(2 - $0.offset))) : 0 }.reduce(0, +)
        return numRow * 8 + numCol
    }
    
    @objc
    func day6question1() -> String {
        let input = readCSV("InputYear2020Day6").components(separatedBy: "\n\n")
        let result = input.map { Set($0.components(separatedBy: .newlines).joined().map { String($0) }).count }.reduce(0, +)
        return "\(result)"
    }
    
    @objc
    func day6question2() -> String {
        let input = readCSV("InputYear2020Day6").components(separatedBy: "\n\n").map { $0.components(separatedBy: .newlines) }
        let result = input.map { answers -> Int in
            answers[0].filter { item in answers.filter { $0.contains(item) }.count == answers.count }.count
        }.reduce(0, +)
        return "\(result)"
    }
    
    struct Bag: Equatable, Hashable {
        let id: Int
        let feature: String
        let color: String
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }
    
}
