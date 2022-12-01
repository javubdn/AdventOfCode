//
//  BurrowSystem.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 15/11/22.
//

import Foundation

protocol Location {
    
    var id: Int { get }
    var occupant: Amphipod? { get set }
    func canMove(_ location: Location, _ burrow: Burrow) -> Bool
    func copy() -> Location
    
}

class Hallway: Location {
    
    let id: Int
    var occupant: Amphipod? = nil
    
    init(id: Int, occupant: Amphipod? = nil) {
        self.id = id
        self.occupant = occupant
    }
    
    func canMove(_ location: Location, _ burrow: Burrow) -> Bool {
        guard let room = location as? Room else { return false }
        guard occupant!.type == room.type else { return false }
        let rooms = burrow.locations.values.filter { location in
            guard let myRoom = location as? Room else { return false }
            return myRoom.type == room.type && myRoom.id > room.id
        }
        for nextRoom in rooms {
            if !BurrowSystem.matches(nextRoom as! Room) {
                return false
            }
        }
        return true
    }
    
    func copy() -> Location {
        Hallway(id: id, occupant: occupant)
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
    
    func canMove(_ location: Location, _ burrow: Burrow) -> Bool {
        switch location {
        case let hallway as Hallway: return canMoveHallway(hallway, burrow)
        case let room as Room: return canMoveRoom(room, burrow)
        default: return false
        }
    }
    
    private func canMoveHallway(_ hallway: Hallway, _ burrow: Burrow) -> Bool {
        guard BurrowSystem.matches(self) else { return true }
        let rooms = burrow.locations.values.filter { location in
            guard let myRoom = location as? Room else { return false }
            return myRoom.type == type && myRoom.id > id
        }
        for nextRoom in rooms {
            if !BurrowSystem.matches(nextRoom as! Room) {
                return true
            }
        }
        return false
    }
    
    private func canMoveRoom(_ room: Room, _ burrow: Burrow) -> Bool {
        guard type != room.type else { return false }
        guard occupant!.type != type else { return false}
        guard occupant!.type == room.type else { return false}
        
        let rooms = burrow.locations.values.filter { location in
            guard let myRoom = location as? Room else { return false }
            return myRoom.type == type && myRoom.id > room.id
        }
        for nextRoom in rooms {
            if !BurrowSystem.matches(nextRoom as! Room) {
                return false
            }
        }
        return true
    }
    
    func copy() -> Location {
        Room(type: type, id: id, occupant: occupant)
    }
    
}

class Burrow: Hashable {
    
    let locations: [Int: Location]
    
    func hash(into hasher: inout Hasher) { }
    
    static func == (lhs: Burrow, rhs: Burrow) -> Bool {
        for key in lhs.locations.keys {
            if lhs.locations[key]?.occupant?.type != rhs.locations[key]?.occupant?.type {
                return false
            }
        }
        return true
    }
    
    init(_ locations: [Int: Location]) {
        self.locations = locations
    }
    
}

class BurrowSystem {
    
    let burrow: Burrow
    let neighbours: [[Int]]
    let doorWays: [AmphipodType: Int] = [.amber: 3, .bronze: 7, .copper: 11, .desert: 15]
    
    init(burrow: Burrow, neighbours: [[Int]]) {
        self.burrow = burrow
        self.neighbours = neighbours
    }
    
    func solve() -> Int {
        var states = [(burrow, 0)]
        var seen = Set<Burrow>()
        
        while !states.isEmpty {
            let (current, cost) = states.removeFirst()
            if seen.contains(current) {
                continue
            }
            if isDone(current) {
                return cost
            }
            seen.insert(current)
            
            for (nextBurrow, burrowCost) in nextburrows(current) {
                let nextCost = cost + burrowCost
                if let index = states.firstIndex(where: { $0.1 > nextCost }) {
                    states.insert((nextBurrow, nextCost), at: index)
                } else {
                    states.append((nextBurrow, nextCost))
                }
            }
        }
        return 0
    }
    
    func isDone(_ burrow: Burrow) -> Bool {
        for location in burrow.locations.values {
            guard let room = location as? Room else { continue }
            if !BurrowSystem.matches(room) { return false }
        }
        return true
    }
    
    private func nextburrows(_ burrow: Burrow) -> [(Burrow, Int)] {
        var burrows: [(Burrow, Int)] = []
        for id in 1...burrow.locations.count {
            let moves = nextMoves(burrow, id)
            for move in moves {
                let moveCost = move.cost
                let nextId = move.nextId
                let nextburrow = swap(burrow, id, nextId)
                burrows.append((nextburrow, moveCost))
            }
        }
        return burrows
    }
    
        
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
    func swap(_ burrow: Burrow, _ id1: Int, _ id2: Int) -> Burrow {
        var locations: [Int: Location] = [:]
        for id in burrow.locations.keys {
            locations[id] = burrow.locations[id]?.copy()
        }
        let aux = locations[id1]!.occupant
        locations[id1]!.occupant = locations[id2]!.occupant
        locations[id2]!.occupant = aux
        return Burrow(locations)
    }
    
}
