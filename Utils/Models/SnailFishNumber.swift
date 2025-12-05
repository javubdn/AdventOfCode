//
//  SnailFishNumber.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 6/9/22.
//

import Foundation

class SnailFishPair: SnailFishNumber {
    
    override func findLevel4(_ level: Int) -> SnailFishPair? {
        }
    }
    
    override func findGreater9() -> SnailFishValue? {
        if let foundInLeft = left.findGreater9() {
            return foundInLeft
        }
        return right.findGreater9()
    }
    
    func explode() {
        addValue(to: .left)
        addValue(to: .right)
        let newNode = SnailFishValue(value: 0)
        newNode.parent = parent
        if side == .left {
            parent?.left = newNode
        } else {
            parent?.right = newNode
        }
        newNode.side = side
    }
    
    private func addValue(to side: SnailSide) {
        var current: SnailFishNumber? = self
        while true {
            guard let currentInside = current else { break }
            guard currentInside.side == side else {
                current = side == .left ? currentInside.parent?.left : currentInside.parent?.right
                break
            }
            current = currentInside.parent
        }
        if current != nil {
            while current is SnailFishPair {
                current = side == .left ? (current as! SnailFishPair).right : (current as! SnailFishPair).left
            }
            (current as! SnailFishValue).value += side == .left ? (left as! SnailFishValue).value : (right as! SnailFishValue).value
        }
    }
    
    override func magnitude() -> Int {
        left.magnitude() * 3 + right.magnitude() * 2
    }
    
    override func getValue() -> String {
        let leftString = left.getValue()
        let rightString = right.getValue()
        return "[\(leftString),\(rightString)]"
    }
    
    func copy() -> SnailFishPair {
        SnailFishPair(from: getValue())
    }
    
}
