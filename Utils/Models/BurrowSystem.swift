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
        guard occupant! != type else { return false}
        guard occupant! == room.type else { return false}
        
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
    
    func setOccupant(_ occupant: AmphipodType?) {
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
            if lhs.at(index).occupant != rhs.at(index).occupant {
                return false
            }
        }
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
    
    func solve() -> Int {
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
                if foundCost == 19167 {
                    print(foundCost)
                }
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
        var total: Double = 0
        for id in 1...burrow.size() {
            let location = burrow.at(id)
            guard let _ = location.occupant else { continue }
            if let room = location as? Room {
                if BurrowSystem.matches(room) && !block(burrow, id) {
                    continue
                }
            }
            total += simplePathCost(burrow, id)
        }
//        return total
        return Int(floor(total))
    }
    
    func simplePathCost(_ burrow: Burrow, _ id: Int) -> Double {
        let startAt = burrow.at(id)
        let amphipod = startAt.occupant!
        let exitDist = distToHall(startAt)
        
        let exitDoor = startAt is Hallway ? startAt : burrow.at(doorWays[(startAt as! Room).type]!)
        let homeDoor = burrow.at(doorWays[amphipod]!)
        
        var hallDist = abs(exitDoor.id - homeDoor.id)
        hallDist += hallDist == 0 ? 2 : 0
        let fullDist = Double(exitDist) + Double(hallDist) + 1.5
//        return Int(floor(fullDist * Double(amphipod.cost())))
        return fullDist * Double(amphipod.cost())
    }
    
    func distToHall(_ location: Location) -> Int {
        guard let room = location as? Room else { return 0 }
        return room.id
//        guard let room = location as? Room else { return 0 }
//        return room.id % 2 == 0 ? 1 : 2
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
        
        let moveCost = amphipod.cost()
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
        return amphipod == room.type
    }
    
    private func block(_ burrow: Burrow, _ id: Int) -> Bool {
        guard burrow.at(id) is Room else { return false }
        var nextId = id + 1
        while let nextRoom = burrow.at(nextId) as? Room {
            if let occupant = nextRoom.occupant {
                if occupant != nextRoom.type {
                    return true
                }
            } else {
                return true
            }
            nextId += 1
        }
        return false
    }
    
    func swap(_ burrow: Burrow, _ id1: Int, _ id2: Int) -> Burrow {
        let burrowCopy = burrow.copy()
        let aux = burrowCopy.at(id1).occupant
        burrowCopy.at(id1).setOccupant(burrowCopy.at(id2).occupant)
        burrowCopy.at(id2).setOccupant(aux)
        return burrowCopy
    }
    
}
