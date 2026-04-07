//
//  ValvesPathFinder.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 24/2/23.
//

import Foundation

class ValvesPathFinder {
    
    
    
    
    
    
    
    
    
        
    
    
    private func costForDemiMovement(_ locationFinished: String,
                                     _ timeMovement: Int,
                                     _ totalFlow:Int) -> Int {
        let validValves = getValidValves(locationFinished, seen, timeTaken, timeAllowed)
        let combinationCosts = validValves.map { valve in
        }
        guard combinationCosts.count > 0 else { return totalFlow }
        return combinationCosts.max()!
    }
    
    private func getValidValves(_ location: String, _ seen: Set<String>, _ timeTaken: Int, _ timeAllowed: Int) -> [String: Int] {
        return cheapestPathCosts[location]!
            .filter { !seen.contains($0.key) }
            .filter { $0.value + timeTaken + 1 < timeAllowed }
    }
    
}
