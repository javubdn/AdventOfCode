//
//  SnailFishNumber.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 6/9/22.
//

import Foundation

class SnailFishPair: SnailFishNumber {
    
    var left: SnailFishNumber
    var right: SnailFishNumber
    
    init(left: SnailFishNumber, right: SnailFishNumber) {
        self.left = left
        self.right = right
        self.left.side = .left
        self.right.side = .right
        super.init()
        self.left.parent = self
        self.right.parent = self
    }
    
    convenience init(from input: String) {
        var levels: [[SnailFishNumber]] = [[]]
        for item in input {
            switch item {
            case "[": levels.append([])
            case "]":
                let currentLevel = levels.removeLast()
                let snailFishPair = SnailFishPair(left: currentLevel[0], right: currentLevel[1])
                currentLevel[0].parent = snailFishPair
                currentLevel[0].side = .left
                currentLevel[1].parent = snailFishPair
                currentLevel[1].side = .right
                levels[levels.count-1].append(snailFishPair)
            case ",": break
            default:
                let value = Int(String(item))!
                let snailFishValue = SnailFishValue(value: value)
                levels[levels.count-1].append(snailFishValue)
            }
        }
        let snailFishNumber = levels.first![0] as! SnailFishPair
        self.init(left: snailFishNumber.left, right: snailFishNumber.right)
    }
    
    func optimise() -> SnailFishPair {
        while true {
            if let snailToExplode = findLevel4(4) {
                snailToExplode.explode()
            } else if let valueMoreThan9 = findGreater9() {
                valueMoreThan9.split()
            } else {
                break
            }
        }
        
        return self
    }
    
    override func findLevel4(_ level: Int) -> SnailFishPair? {
        guard level > 0 else {
            if let left = left.findLevel4(level) {
                return left
            }
            if let right = right.findLevel4(level) {
                return right
            }
            return self
        }
        if let snail = left.findLevel4(level-1) {
            return snail
        }
        return right.findLevel4(level-1)
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
