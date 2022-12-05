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
    func setOccupant(_ occupant: Amphipod?)
    
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
//        let rooms = burrow.locations.values.filter { location in
//            guard let myRoom = location as? Room else { return false }
//            return myRoom.type == room.type && myRoom.id > room.id
//        }
        let rooms = burrow.getRooms(room.type, room.id)
        for nextRoom in rooms {
            if !BurrowSystem.matches(nextRoom) {
                return false
            }
        }
        return true
    }
    
    func copy() -> Location {
        Hallway(id: id, occupant: occupant)
    }
    
    func setOccupant(_ occupant: Amphipod?) {
        self.occupant = occupant
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
//        let rooms = burrow.locations.values.filter { location in
//            guard let myRoom = location as? Room else { return false }
//            return myRoom.type == type && myRoom.id > id
//        }
        let rooms = burrow.getRooms(type, id)
        for nextRoom in rooms {
            if !BurrowSystem.matches(nextRoom) {
                return true
            }
        }
        return false
    }
    
    private func canMoveRoom(_ room: Room, _ burrow: Burrow) -> Bool {
        guard type != room.type else { return false }
        guard occupant!.type != type else { return false}
        guard occupant!.type == room.type else { return false}
        
//        let rooms = burrow.locations.values.filter { location in
//            guard let myRoom = location as? Room else { return false }
//            return myRoom.type == type && myRoom.id > room.id
//        }
        let rooms = burrow.getRooms(room.type, room.id)
        for nextRoom in rooms {
            if !BurrowSystem.matches(nextRoom) {
                return false
            }
        }
        return true
    }
    
    func copy() -> Location {
        Room(type: type, id: id, occupant: occupant)
    }
    
    func setOccupant(_ occupant: Amphipod?) {
        self.occupant = occupant
    }
    
}

class Burrow: Hashable {
    
    let locations: [Location]
    
    
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
    
    struct Move: Hashable {
        let nextId: Int
        let cost: Int
    }
    
        
        
                
                
    private func canMove(_ location1: Location, _ location2: Location, _ burrow: Burrow) -> Bool {
        location1.canMove(location2, burrow)
    }
    
    static func matches(_ room: Room) -> Bool {
        guard let amphipod = room.occupant else { return false }
        return amphipod.type == room.type
    }
    
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
