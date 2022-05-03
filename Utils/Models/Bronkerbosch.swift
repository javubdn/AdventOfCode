//
//  Bronkerbosch.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 3/5/22.
//

import Foundation

class Bronkerbosch<T: Hashable> {
    
    private var bestR: Set<T> = Set()
    private var neighbors: [T: Set<T>]
    var counter = 1
    init(_ neighbors: [T: Set<T>]) {
        self.neighbors = neighbors
    }
    
    func largestClique() -> Set<T> {
        execute(p: Set(neighbors.keys))
        return bestR
    }
    
    private func execute(p: Set<T>, r: Set<T> = Set(), x: Set<T> = Set()) {
        print(counter)
        counter += 1
        guard !p.isEmpty || !x.isEmpty else {
            if r.count > bestR.count { bestR = r }
            return
        }
        let mostNeighborsOfPandX: T = p.union(x).max { item1, item2 in
            let n1 = neighbors[item1]
            let n2 = neighbors[item2]
            let count1 = n1!.count
            let count2 = n2!.count
            return count2 > count1
        }!
        var pWithoutNeighbors = p
        neighbors[mostNeighborsOfPandX]!.forEach { pWithoutNeighbors.remove($0) }
        pWithoutNeighbors.forEach { v in
            let neighborsOfV = neighbors[v]!
            var newR = r
            newR.insert(v)
            execute(p: p.intersection(neighborsOfV), r: newR, x: x.intersection(neighborsOfV))
        }
    }
    
}
