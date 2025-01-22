//
//  HexagonalTile.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 30/8/22.
//

import Foundation

class HexagonalTile {
    
    let steps: [String: Int]
    var whiteSide: Bool = true
    
    init(steps: [String: Int]) {
        self.steps = steps
    }
    
    convenience init(from input: String) {
        var steps: [String: Int] = ["w": 0, "e": 0, "nw": 0, "ne": 0, "sw": 0, "se": 0]
        let opAlt = ["w": [["e", ""], ["ne", "nw"], ["se", "sw"]],
                     "e": [["w", ""], ["nw", "ne"], ["sw", "se"]],
                     "nw": [["se", ""], ["e", "ne"], ["sw", "w"]],
                     "ne": [["sw", ""], ["w", "nw"], ["se", "e"]],
                     "sw": [["ne", ""], ["nw", "w"], ["e", "se"]],
                     "se": [["nw", ""], ["ne", "e"], ["w", "sw"]]]
        
        var index = 0
        while index<input.count {
            let value: String
            switch input[index] {
            case "w": value = "w"
                index += 1
            case "e": value = "e"
                index += 1
            case "n": value = String(input[index...index+1])
                index += 2
            case "s": value = String(input[index...index+1])
                index += 2
            default: value = ""
            }
            
            var found = false
            for item in opAlt[value]! {
                if steps[item[0]]! > 0 {
                    steps[item[0]]! -= 1
                    if let n = steps[item[1]] { steps[item[1]] = n + 1 }
                    found = true
                    break
                }
            }
            if !found {
                steps[value]! += 1
            }
        }
        self.init(steps: steps)
    }
    
    convenience init(path: String) {
        let components = path.components(separatedBy: "-")
        let steps = ["w": Int(components[0])!, "e": Int(components[1])!, "nw": Int(components[2])!,
                     "ne": Int(components[3])!, "sw": Int(components[4])!, "se": Int(components[5])!]
        self.init(steps: steps)
    }
    
    func rotate() {
        whiteSide = !whiteSide
    }
    
    func getPath() -> String {
        "\(String(steps["w"]!))-\(String(steps["e"]!))-\(String(steps["nw"]!))-\(String(steps["ne"]!))-\(String(steps["sw"]!))-\(String(steps["se"]!))"
    }
    
    func neighbours() -> [String] {
        ["w", "e", "nw", "ne", "sw", "se"].map { applyStep($0) }
    }
    
    private func applyStep(_ step: String) -> String {
        var neighbourSteps = steps
        let opAlt = ["w": [["e", ""], ["ne", "nw"], ["se", "sw"]],
                     "e": [["w", ""], ["nw", "ne"], ["sw", "se"]],
                     "nw": [["se", ""], ["e", "ne"], ["sw", "w"]],
                     "ne": [["sw", ""], ["w", "nw"], ["se", "e"]],
                     "sw": [["ne", ""], ["nw", "w"], ["e", "se"]],
                     "se": [["nw", ""], ["ne", "e"], ["w", "sw"]]]
        var found = false
        for item in opAlt[step]! {
            if neighbourSteps[item[0]]! > 0 {
                neighbourSteps[item[0]]! -= 1
                if let n = neighbourSteps[item[1]] { neighbourSteps[item[1]] = n + 1 }
                found = true
                break
            }
        }
        if !found {
            neighbourSteps[step]! += 1
        }
        
        return "\(String(neighbourSteps["w"]!))-\(String(neighbourSteps["e"]!))-\(String(neighbourSteps["nw"]!))-\(String(neighbourSteps["ne"]!))-\(String(neighbourSteps["sw"]!))-\(String(neighbourSteps["se"]!))"
    }
    
}

extension HexagonalTile: Hashable {
    
    func hash(into hasher: inout Hasher) { }
    
    static func == (lhs: HexagonalTile, rhs: HexagonalTile) -> Bool {
        lhs.getPath() == rhs.getPath()
    }
    
}
