//
//  Moon.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 20/5/22.
//

import Foundation

class Moon {
    
    let id: Int
    var position: (x: Int, y: Int, z: Int)
    var speed: (x: Int, y: Int, z: Int) = (0, 0, 0)
    
    init(_ id: Int, position: (x: Int, y: Int, z: Int)) {
        self.id = id
        self.position = position
    }
    
    func updateSpeed(_ otherMoons: [Moon]) {
        let moons = otherMoons.filter { $0.id != id }
        let greaterX = moons.filter { $0.position.x > position.x }.count
        let lesserX = moons.filter { $0.position.x < position.x }.count
        let greaterY = moons.filter { $0.position.y > position.y }.count
        let lesserY = moons.filter { $0.position.y < position.y }.count
        let greaterZ = moons.filter { $0.position.z > position.z }.count
        let lesserZ = moons.filter { $0.position.z < position.z }.count
        speed.x += (greaterX - lesserX)
        speed.y += (greaterY - lesserY)
        speed.z += (greaterZ - lesserZ)
    }
    
    func move() {
        position.x += speed.x
        position.y += speed.y
        position.z += speed.z
    }
    
    func energy() -> Int {
        (abs(position.x) + abs(position.y) + abs(position.z)) * (abs(speed.x) + abs(speed.y) + abs(speed.z))
    }
    
    struct MoonPair: Hashable {
        let position: Int
        let speed: Int
    }
    
    func getX() -> MoonPair {
        MoonPair(position: position.x, speed: speed.x)
    }
    
    func getY() -> MoonPair {
        MoonPair(position: position.y, speed: speed.y)
    }
    
    func getZ() -> MoonPair {
        MoonPair(position: position.z, speed: speed.z)
    }
    
}
