//
//  Position.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 5/1/23.
//

class Position: Hashable {
    
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    func hash(into hasher: inout Hasher) { }
    
    static func == (lhs: Position, rhs: Position) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
    
}
