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
    
    func searchPaths(_ location: String,
                     _ timeAllowed: Int,
                     _ seen: Set<String> = Set(),
                     _ timeTaken: Int = 0,
                     _ totalFlow: Int = 0) -> Int {
        let valveWays = cheapestPathCosts[location]!
            .filter { !seen.contains($0.key) }
            .filter { $0.value + timeTaken + 1 < timeAllowed }
            .map { item in
                var seen1 = seen
                seen1.insert(item.key)
                return searchPaths(item.key,
                                   timeAllowed,
                                   seen1,
                                   timeTaken + item.value + 1,
                                   totalFlow + (timeAllowed - timeTaken - item.value - 1) * valves.first { $0.name == item.key }!.rate)
            }
        
        guard valveWays.count > 0 else { return totalFlow }
        return valveWays.max()!
    }
    
            return costForDemiMovement(location.1, location.0, seen, timeAllowed, timeTaken, timeCurrentValve.0, totalFlow)
            return costForDemiMovement(location.0, location.1, seen, timeAllowed, timeTaken, timeCurrentValve.1, totalFlow)
            let validNamesA = getValidValves(location.0, seen, timeTaken, timeAllowed).map { $0.key }
            let validNamesB = getValidValves(location.1, seen, timeTaken, timeAllowed).map { $0.key }
            
            let validCombinations = Utils.cartesianProduct(lhs: validNamesA, rhs: validNamesB)
                .filter { $0.0 != $0.1 }
                var seen1 = seen
                seen1.insert(combination.0)
                seen1.insert(combination.1)
                let item1 = valves.first { $0.name == combination.0 }!
                let item2 = valves.first { $0.name == combination.1 }!
                let flow1 = (timeAllowed - timeTaken - cheapestPathCosts[location.0]![combination.0]! - 1) * item1.rate
                let flow2 = (timeAllowed - timeTaken - cheapestPathCosts[location.1]![combination.1]! - 1) * item2.rate
                let newTimeTaken = min(cheapestPathCosts[location.0]![combination.0]!, cheapestPathCosts[location.1]![combination.1]!) + 1
                let newTime1 = cheapestPathCosts[location.0]![combination.0]! + 1 - newTimeTaken
                let newTime2 = cheapestPathCosts[location.1]![combination.1]! + 1 - newTimeTaken
                                   timeAllowed,
                                   seen1,
                                   timeTaken + newTimeTaken,
                                   (newTime1, newTime2),
            )
        }
        val zeroFlowRooms = rooms.values.filter { it.flowRate == 0 || it.name == "AA" }.map { it.name }.toSet()
        shortestPaths.values.forEach { it.keys.removeAll(zeroFlowRooms) }
        val canGetToFromAA: Set<String> = shortestPaths.getValue("AA").keys
        return shortestPaths.filter { it.key in canGetToFromAA || it.key == "AA" }
    }
    
}
