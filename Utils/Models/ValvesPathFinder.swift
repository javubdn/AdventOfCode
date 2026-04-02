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
            var seen1 = seen
            seen1.insert(valve.key)
            let flow = (timeAllowed - timeTaken - valve.value - 1) * valves.first { $0.name == valve.key }!.rate
            let newTimeTaken = min(valve.value + 1, timeMovement)
            let newTime1 = timeMovement - newTimeTaken
            let newTime2 = valve.value + 1 - newTimeTaken
            return searchPath2((locationMovement, valve.key),
            )
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
