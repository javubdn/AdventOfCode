//
//  BurrowSystem.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 15/11/22.
//

import Foundation

protocol Location {
    
    var id: Int { get }
    var occupant: AmphipodType? { get set }
    func canMove(_ location: Location, _ burrow: Burrow) -> Bool
    func copy() -> Location
    func setOccupant(_ occupant: AmphipodType?)
    
}

class Hallway: Location {
    
    let id: Int
    var occupant: AmphipodType? = nil
    
    init(id: Int, occupant: AmphipodType? = nil) {
        self.id = id
        self.occupant = occupant
    }
    
    func canMove(_ location: Location, _ burrow: Burrow) -> Bool {
        guard let room = location as? Room else { return false }
        guard occupant! == room.type else { return false }
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
    
    func setOccupant(_ occupant: AmphipodType?) {
        self.occupant = occupant
    }
    
}

class Room: Location {
    
    let type: AmphipodType
    let id: Int
    var occupant: AmphipodType?
    
    init(type: AmphipodType, id: Int, occupant: AmphipodType? = nil) {
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
    
    init(_ locations: [Location]) {
        self.locations = locations
    }
    
    func hash(into hasher: inout Hasher) { }
    
    func at(_ id: Int) -> Location {
        locations[id-1]
    }
    
    func getRooms(_ type: AmphipodType, _ id: Int) -> [Room] {
        locations.filter { location in
            guard let room = location as? Room else { return false }
            return room.type == type && room.id > id
        } as! [Room]
    }
    
    func size() -> Int {
        locations.count
    }
    
    func copy() -> Burrow {
        var locationsCopy: [Location] = []
        for location in locations {
            locationsCopy.append(location.copy())
        }
        return Burrow(locationsCopy)
    }
    
    static func == (lhs: Burrow, rhs: Burrow) -> Bool {
        for index in 1...lhs.size() {
            if lhs.at(index).occupant?.type != rhs.at(index).occupant?.type {
                return false
            }
        }
        
        
//        for locationL in lhs.locations {
//            guard let locationR = rhs.locations.first(where: { $0.id == locationL.id }) else {
//                return false
//            }
//            if locationL.occupant?.type != locationR.occupant?.type {
//                return false
//            }
//        }
        
//        for key in lhs.locations.keys {
//            if lhs.locations[key]?.occupant?.type != rhs.locations[key]?.occupant?.type {
//                return false
//            }
//        }
        return true
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
    
    func solveH() -> Int {
        var states = Heap(elements: [(burrow, distance(burrow))]) { $0.1 < $1.1 }
        var open: Set<Burrow> = Set<Burrow>([burrow])
        var costs: [Burrow: Int] = [burrow: 0]

        while !states.isEmpty {
            let (current, currentDistance) = states.dequeue()!
            if currentDistance == costs[current]! {
                return costs[current]!
            }
            open.remove(current)
            for (nextBurrow, burrowCost) in nextburrows(current) {
                let foundCost = costs[current]! + burrowCost
                if let cost = costs[nextBurrow] {
                    if foundCost >= cost {
                        continue
                    }
                }
                costs[nextBurrow] = foundCost
                if open.contains(nextBurrow) {
                    continue
                }
                open.insert(nextBurrow)
                let nextDistance = distance(nextBurrow)
                let totalCost = nextDistance + foundCost
                states.enqueue((nextBurrow, totalCost))
            }
        }

        return 0
    }
    
    func distance(_ burrow: Burrow) -> Int {
        var total = 0
        for id in 1...burrow.size() {
            let location = burrow.at(id)
            guard let _ = location.occupant else { continue }
            if let room = location as? Room {
                if BurrowSystem.matches(room) {
                    continue
                }
            }
            total += simplePathCost(burrow, id)
        }
        return total
    }
    
    func simplePathCost(_ burrow: Burrow, _ id: Int) -> Int {
        let startAt = burrow.at(id)
        let amphipod = startAt.occupant!
        let exitDist = distToHall(startAt)
        let exitDoor = startAt is Hallway ? startAt : burrow.at(doorWays[(startAt as! Room).type]!)
        
        let homeDoor = burrow.at(doorWays[amphipod.type]!)
        let hallIds = [1, 2, 3, 6, 7, 10, 11, 14, 15, 18, 19]
        
//        let hallDist = abs(hallIds.firstIndex { $0 == exitDoor.id }! - hallIds.firstIndex { $0 == homeDoor.id }!)
        let hallDist = abs(exitDoor.id - homeDoor.id)
        let moveCost = amphipod.cost
        let fullDist = Double(exitDist) + Double(hallDist) + 1.5
        return Int(floor(fullDist * Double(moveCost)))
    }
    
    func distToHall(_ location: Location) -> Int {
        //TODO: Adaptarlo para 4 rooms por tipo
        guard let room = location as? Room else { return 0 }
        return room.id % 2 == 0 ? 1 : 2
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
        for location in burrow.locations {
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
    
    private func nextMoves(_ burrow: Burrow, _ id: Int) -> Set<Move> {
        guard let amphipod = burrow.at(id).occupant else { return [] }
        
        let moveCost = amphipod.cost
        var queue = [(0, id)]
        var visited = Set<Int>()
        var moves = Set<Move>()
        
        while !queue.isEmpty {
            let (cost, current) = queue.removeFirst()
            
            for neighbor in neighbours[current-1] {
                guard !visited.contains(neighbor) else { continue }
                guard burrow.at(neighbor).occupant == nil else { continue }
                
                let nextCost = cost + moveCost
                queue.append((nextCost, neighbor))
                
                if doorWays.values.contains(neighbor) { continue }
                if !canMove(burrow.at(id), burrow.at(neighbor), burrow) { continue }
                moves.insert(Move(nextId: neighbor, cost: nextCost))
            }
            visited.insert(current)
        }
        return moves
    }
    
    private func canMove(_ location1: Location, _ location2: Location, _ burrow: Burrow) -> Bool {
        location1.canMove(location2, burrow)
    }
    
    static func matches(_ room: Room) -> Bool {
        guard let amphipod = room.occupant else { return false }
        return amphipod.type == room.type
    }
    
    func swap(_ burrow: Burrow, _ id1: Int, _ id2: Int) -> Burrow {
//        var locations: [Location] = []
//        for id in 1...burrow.size() {
//            locations[id-1] = burrow.at(id).copy()
//        }
//        let aux = locations[id1]!.occupant
//        locations[id1]!.occupant = locations[id2]!.occupant
//        locations[id2]!.occupant = aux
//        return Burrow(locations)
        let burrowCopy = burrow.copy()
        let aux = burrowCopy.at(id1).occupant
        burrowCopy.at(id1).setOccupant(burrowCopy.at(id2).occupant)
        burrowCopy.at(id2).setOccupant(aux)
        return burrowCopy
    }
    
}
