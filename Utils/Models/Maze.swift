//
//  Maze.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 8/6/22.
//

import Foundation

class Maze {
    
    struct PointMaze: Hashable {
        let x: Int
        let y: Int
        
        func neighbors() -> [PointMaze] {
            [PointMaze(x: x, y: y-1),
             PointMaze(x: x, y: y+1),
             PointMaze(x: x-1, y: y),
             PointMaze(x: x+1, y: y)]
        }
    }
    
    struct PointsAndKeys: Hashable {
        let points: Set<PointMaze>
        let keys: Set<String>
    }
    
    private let starts: Set<PointMaze>
    private let keys: [PointMaze: String]
    private let doors: [PointMaze: String]
    private let openSpaces: Set<PointMaze>
    
    init(starts: Set<PointMaze>, keys: [PointMaze: String], doors: [PointMaze: String], openSpaces: Set<PointMaze>) {
        self.starts = starts
        self.keys = keys
        self.doors = doors
        self.openSpaces = openSpaces
    }
    
    convenience init(from input: [String]) {
        var starts: Set<PointMaze> = Set()
        var keys: [PointMaze: String] = [:]
        var doors: [PointMaze: String] = [:]
        var openSpaces: Set<PointMaze> = Set()
        input.enumerated().forEach { y, row in
            row.enumerated().forEach { x, c in
                let place = PointMaze(x: x, y: y)
                if c == "@" { starts.insert(place) }
                if c != "#" { openSpaces.insert(place)}
                if "abcdefghijklmnopqrstuvwxyz".contains(c) { keys[place] = String(c) }
                if "ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(c) { doors[place] = String(c) }
            }
        }
        self.init(starts: starts, keys: keys, doors: doors, openSpaces: openSpaces)
    }
    
    func minimumSteps() -> Int {
        minimumSteps(from: starts, haveKeys: Set(), seen: [:]).0
    }
    
    func minimumSteps(from: Set<PointMaze>,
                      haveKeys: Set<String>,
                      seen: [PointsAndKeys: Int]) -> (Int, [PointsAndKeys: Int]) {
        let state = PointsAndKeys(points: from, keys: haveKeys)
        var seen = seen
        if let result = seen[state] { return (result, seen) }
        let answer = findReachableFromPoints(from: from, haveKeys: haveKeys).map { entry -> Int in
            let (at, dist, cause) = entry.value
            var nextPoints = from
            nextPoints.remove(cause)
            nextPoints.insert(at)
            var nextKeys = haveKeys
            nextKeys.insert(entry.key)
            let (minDistance, newSeen) = minimumSteps(from: nextPoints, haveKeys: nextKeys, seen: seen)
            seen = newSeen
            return dist + minDistance
        }.min() ?? 0
        seen[state] = answer
        return (answer, seen)
    }
    
    private func findReachableFromPoints(from: Set<PointMaze>,
                                         haveKeys: Set<String>) -> [String: (PointMaze, Int, PointMaze)] {
        from.reduce(into: [String: (PointMaze, Int, PointMaze)]()) { partialResult, point in
            findReachableKeys(from: point, haveKeys: haveKeys).forEach { entry in
                partialResult[entry.key] = (entry.value.0, entry.value.1, point)
            }
        }
    }
    
    private func findReachableKeys(from origin: PointMaze,
                                   haveKeys: Set<String> = Set()) -> [String: (PointMaze, Int)] {
        var queue = [origin]
        var distance = [origin: 0]
        var keyDistance: [String: (PointMaze, Int)] = [:]
        while !queue.isEmpty {
            let next = queue.removeFirst()
            next.neighbors().filter { openSpaces.contains($0) }.filter { distance[$0] == nil }.forEach { point in
                distance[point] = distance[next]! + 1
                let door = doors[point]
                let key = keys[point]
                if door == nil || haveKeys.contains(door!.lowercased()) {
                    if key != nil && !haveKeys.contains(key!) {
                        keyDistance[key!] = (point, distance[point]!)
                    } else {
                        queue.append(point)
                    }
                }
            }
        }
        return keyDistance
    }
    
}
