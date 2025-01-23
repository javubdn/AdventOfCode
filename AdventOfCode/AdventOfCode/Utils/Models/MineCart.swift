//
//  MineCart.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 29/3/22.
//

import Foundation

class MineCart {
    private(set) var id: Int
    var address: Direction
    var nextMovement: TurnDirection
    var position: (x: Int, y: Int)
    
    init(id: Int, address: Direction, nextMovement: TurnDirection, position: (x: Int, y: Int)) {
        self.id = id
        self.address = address
        self.nextMovement = nextMovement
        self.position = position
    }
    
    func updateMovement(_ cartMap: [[String]]) {
        let currentItem = cartMap[position.y][position.x]
        switch currentItem {
        case "/": address = address == .west ? .south : address == .east ? .north : address == .north ? .east : .west
        case "\\": address = address == .west ? .north : address == .east ? .south : address == .north ? .west : .east
        case "+":
            address = address.turn(nextMovement)
            nextMovement = nextMovement == .left ? .same : nextMovement == .same ? .right : .left
        default: break
        }
    }
}
