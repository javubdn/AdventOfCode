//
//  BurrowSystem.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 15/11/22.
//

import Foundation

protocol Location {
    
    
}

class Hallway: Location {
    
    let id: Int
    var occupant: Amphipod? = nil
    
    init(id: Int) {
        self.id = id
    }
    
}

class Room: Location {
    
    let type: AmphipodType
    let id: Int
    var occupant: Amphipod?
    
    init(type: AmphipodType, id: Int, occupant: Amphipod? = nil) {
        self.type = type
        self.id = id
        self.occupant = occupant
    }
    
}

class Burrow: Hashable {
    
    let locations: [Location]
    
    func hash(into hasher: inout Hasher) { }
    
    static func == (lhs: Burrow, rhs: Burrow) -> Bool {
        //TODO: calcular esto
        return true
    }
    
    init(_ locations: [Location]) {
        self.locations = locations
    }
    
}

class BurrowSystem {
    
    func solve(_ initial: Burrow) -> Int {
        var states = [(initial, 0)]
        var seen = Set<Burrow>()

        while !states.isEmpty {
            var (current, cost) = states.removeFirst()
            if seen.contains(current) {
                continue
            }
            if isDone(current) {
                return cost
            }
            seen.insert(current)
            
            for (nextBurrow, burrowCost) in nextburrows(current) {
                let nextCost = cost + burrowCost
                states.append((nextBurrow, nextCost))
            }
        }
        return 0
    }
    
    func isDone(_ burrow: Burrow) -> Bool {
        for location in burrow.locations {
            if location is Hallway {
                continue
            }
            if matches(location) {
                return false
            }
        }
        return true
    }
    
    private func nextburrows(_ burrow: Burrow) -> [(Burrow, Int)] {
        let burrows: [(Burrow, Int)] = []
        
        for id in 1...burrow.locations.count {
            let moves = nextMoves(burrow, id)
            for (moveCost, nextId) in moves {
                let nextburrow = swap(burrow, id, nextId)
                burrows.append((nextburrow, moveCost))
            }
        }
        return burrows
    }
    
    private func nextMoves(_ burrow: Burrow, _ id: Int) -> [] {
        amphipod = burrow[idx].occupant
        isnothing(amphipod) && return []
        
        # Starting at the indicated location, perform a breadth-first search for
            # all the spaces that can be reached from the given location.
                movecost = COST[amphipod]
                queue    = Vector{Move}([(0, idx)])
        visited  = Set{Int64}()
        moves    = Set{Move}()
        
        while !isempty(queue)
                (cost, current) = pop!(queue)
                
                for neighbor in NEIGHBORS[current]
                neighbor ∈ visited && continue
                isempty(burrow[neighbor]) || continue
                
                nextcost = cost + movecost
                pushfirst!(queue, (nextcost, neighbor))
                
                # Don't keep any moves that would stop in a doorway.
                neighbor ∈ values(DOORWAYS) && continue
                canmove(burrow[idx], burrow[neighbor], burrow) || continue
                push!(moves, (nextcost, neighbor))
                end
                push!(visited, current)
                end
                return moves
    }
    
}
