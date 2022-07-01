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
    
}
