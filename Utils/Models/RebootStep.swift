//
//  RebootStep.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 6/10/22.
//

import Foundation

class RebootStep {
    
    let on: Bool
    let minX: Int
    let maxX: Int
    let minY: Int
    let maxY: Int
    let minZ: Int
    let maxZ: Int
    
    init(_ on: Bool, _ minX: Int, _ maxX: Int, _ minY: Int, _ maxY: Int, _ minZ: Int, _ maxZ: Int) {
        self.on = on
        self.minX = minX
        self.maxX = maxX
        self.minY = minY
        self.maxY = maxY
        self.minZ = minZ
        self.maxZ = maxZ
    }
    
    convenience init(_ input: String) {
        let elements = input.components(separatedBy: ",")
        let firstPart = elements[0].components(separatedBy: "=")
        let intervalX = firstPart[1].components(separatedBy: "..")
        let on = firstPart[0].components(separatedBy: .whitespaces)[0] == "on"
        let minX = Int(intervalX[0])!
        let maxX = Int(intervalX[1])!
        let intervalY = elements[1].components(separatedBy: "=")[1].components(separatedBy: "..")
        let minY = Int(intervalY[0])!
        let maxY = Int(intervalY[1])!
        let intervalZ = elements[2].components(separatedBy: "=")[1].components(separatedBy: "..")
        let minZ = Int(intervalZ[0])!
        let maxZ = Int(intervalZ[1])!
        self.init(on, minX, maxX, minY, maxY, minZ, maxZ)
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
