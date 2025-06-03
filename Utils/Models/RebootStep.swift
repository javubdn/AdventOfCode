//
//  RebootStep.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 6/10/22.
//

import Foundation

class RebootStep {
    
    
    }
    
    func intersects(_ other: RebootStep) -> Bool {
        minX <= other.maxX && maxX >= other.minX
        && minY <= other.maxY && maxY >= other.minY
        && minZ <= other.maxZ && maxZ >= other.minZ
    }
    
    func intersect(_ other: RebootStep) -> RebootStep? {
        guard intersects(other) else { return nil }
        return RebootStep(!on,
                          max(minX, other.minX),
                          min(maxX, other.maxX),
                          max(minY, other.minY),
                          min(maxY, other.maxY),
                          max(minZ, other.minZ),
                          min(maxZ, other.maxZ))
    }
    
    func volume() -> Int {
        (maxX - minX + 1) * (maxY - minY + 1) * (maxZ - minZ + 1) * (on ? 1 : -1)
    }
    
    static func solve(_ cubesToUse: [RebootStep]) -> Int {
        var volumes: [RebootStep] = []
        cubesToUse.forEach { cube in
            volumes.append(contentsOf: volumes.compactMap { $0.intersect(cube) })
            if cube.on { volumes.append(cube) }
        }
        return volumes.map { $0.volume() }.reduce(0, +)
    }
    
}
