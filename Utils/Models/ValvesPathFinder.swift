//
//  ValvesPathFinder.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 24/2/23.
//

import Foundation

class ValvesPathFinder {
    
    private struct ValveRoom {
        let name: String
        let rate: Int
        let valves: [String]
    }
    
    private let valves: [ValveRoom]
    private var cheapestPathCosts: [String: [String: Int]] = [:]
    
    private init(valves: [ValveRoom]) {
        self.valves = valves
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
        
        var shortestPaths = rooms.values.associate {
            it.name to it.paths.associateWith { 1 }.toMutableMap()
        }.toMutableMap()

        shortestPaths.keys.permutations(3).forEach { (waypoint, from, to) ->
            shortestPaths[from, to] = minOf(
                shortestPaths[from, to], // Existing Path
                shortestPaths[from, waypoint] + shortestPaths[waypoint, to] // New Path
            )
        }
        val zeroFlowRooms = rooms.values.filter { it.flowRate == 0 || it.name == "AA" }.map { it.name }.toSet()
        shortestPaths.values.forEach { it.keys.removeAll(zeroFlowRooms) }
        val canGetToFromAA: Set<String> = shortestPaths.getValue("AA").keys
        return shortestPaths.filter { it.key in canGetToFromAA || it.key == "AA" }
    }
    
}
