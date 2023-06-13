//
//  ValvesPathFinder.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 24/2/23.
//

import Foundation

class ValvesPathFinder {
    
    private var valvesCombinations: [String: Int] = [:]
    
    private struct ValveRoom {
        let name: String
        let rate: Int
        let valves: [String]
    }
    
    private let valves: [ValveRoom]
    private var cheapestPathCosts: [String: [String: Int]] = [:]
    
    private init(valves: [ValveRoom]) {
        self.valves = valves
        self.cheapestPathCosts = calculateShortestPaths()
    }
    
    convenience init(_ input: String) {
        let valves = input.components(separatedBy: .newlines).map { Self.getValve($0) }
        self.init(valves: valves)
    }
    
    private static func getValve(_ input: String) -> ValveRoom {
        let regex = try! NSRegularExpression(pattern: #"Valve ([A-Z]+) has flow rate=([0-9]+); tunnel(s)? lead(s)? to valve(s)? ([, A-Z]+)"#)
        let matches = regex.matches(in: input, options: [], range: NSRange(input.startIndex..., in: input))
        let match = matches.first!
        let name = String(input[Range(match.range(at: 1), in: input)!])
        let rate = Int(String(input[Range(match.range(at: 2), in: input)!]))!
        let valves = String(input[Range(match.range(at: 6), in: input)!]).components(separatedBy: ", ")
        return ValveRoom(name: name, rate: rate, valves: valves)
    }
    
    private func calculateShortestPaths() -> [String: [String: Int]] {
        var s: [String: [String: Int]] = [:]
        
        valves.forEach { valve in
            var p: [String: Int] = [:]
            valve.valves.forEach { p[$0] = 1 }
            s[valve.name] = p
        }
        
        s.forEach { item in
            let fromValve = valves.first { $0.name == item.key }!
            guard fromValve.rate > 0 || item.key == "AA" else { return }
            s.forEach { item2 in
                guard item.key != item2.key else { return }
                let toValve = valves.first { $0.name == item2.key }!
                guard toValve.rate > 0 else { return }
                s[item.key]![item2.key] = navigateValve(item.key, item2.key, [])
            }
        }
        
        let zeroFlowRooms = valves.filter { $0.rate == 0 || $0.name == "AA" }.map { $0.name }
        s.keys.forEach { key in
            zeroFlowRooms.forEach { s[key]![$0] = nil }
        }
        
        return s
    }
    
    private func navigateValve(_ from: String, _ to: String, _ used: [String]) -> Int {
        if let bestCost = valvesCombinations["\(from)-\(to)"] {
            return bestCost
        }
        guard !used.contains(from) else { return Int.max }
        let fromValve = valves.first { $0.name == from }!
        if let _ = fromValve.valves.first(where: { $0 == to }) {
            return 1
        }
        var used = used
        used.append(from)
        var bestCost = Int.max
        for valveName in fromValve.valves {
            let cost = navigateValve(valveName, to, used)
            bestCost = min(bestCost, cost)
        }
        let solution = bestCost == Int.max ? Int.max : bestCost + 1
        if solution != Int.max {
            valvesCombinations["\(from)-\(to)"] = solution
        }
        return solution
    }
    
                var seen1 = seen
                seen1.insert(item.key)
                                   timeAllowed,
    
            )
        }
        val zeroFlowRooms = rooms.values.filter { it.flowRate == 0 || it.name == "AA" }.map { it.name }.toSet()
        shortestPaths.values.forEach { it.keys.removeAll(zeroFlowRooms) }
        val canGetToFromAA: Set<String> = shortestPaths.getValue("AA").keys
        return shortestPaths.filter { it.key in canGetToFromAA || it.key == "AA" }
    }
    
}
