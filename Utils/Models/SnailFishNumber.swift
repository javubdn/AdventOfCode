//
//  SnailFishNumber.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 6/9/22.
//

import Foundation

enum SnailSide {
    case left
    case right
    case none
}

class SnailFishNumber {
    
    var parent: SnailFishPair? = nil
    var side: SnailSide = .none
    
    init() {
    }
    
    func sum(_ other: SnailFishNumber) -> SnailFishNumber {
        let snail = SnailFishPair(left: self, right: other)
        self.side = .left
        other.side = .right
        return snail.optimise()
    }
    
    func magnitude() -> Int {
        0
    }
    
}

extension SnailFishNumber: Equatable {
    static func == (lhs: SnailFishNumber, rhs: SnailFishNumber) -> Bool {
        var current = lhs
        var lhsString = ""
        var rhsString = ""
        while current.side != .none {
            lhsString += current.side == .left ? "L" : "R"
            current = current.parent!
        }
        current = rhs
        while current.parent != nil {
            rhsString += current.side == .left ? "L" : "R"
            current = current.parent!
        }
        return lhsString == rhsString
    }
}

class SnailFishValue: SnailFishNumber {
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
}

class SnailFishPair: SnailFishNumber {
    
    var left: SnailFishNumber
    var right: SnailFishNumber
    
    init(left: SnailFishNumber, right: SnailFishNumber) {
        self.left = left
        self.right = right
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
                
            } else {
                break
            }
        }
        
        return self
    }
    
    func findLevel4(_ level: Int) -> SnailFishPair? {
        guard level > 0 else {
            return self
        }
        guard !(left is SnailFishValue) else {
            guard !(right is SnailFishValue) else {
                return nil
            }
            return (right as! SnailFishPair).findLevel4(level-1)
        }
        if let snail = (left as! SnailFishPair).findLevel4(level-1) {
            return snail
        }
        if right is SnailFishValue {
            return nil
        }
        return (right as! SnailFishPair).findLevel4(level-1)
    }
    
    func findGreater9() -> SnailFishValue? {
        return nil
    }
    
    func explode() {
        var current: SnailFishNumber? = self
        while true {
            if let parent = current!.parent {
                if current != parent.left {
                    current = parent.left
                    break
                } else {
                    current = parent
                }
            } else {
                current = nil
                break
            }
        }
        if current != nil {
            while current is SnailFishPair {
                current = (current as! SnailFishPair).right
            }
            (current as! SnailFishValue).value += (left as! SnailFishValue).value
        }
        
        current = self
        while true {
            if let parent = current!.parent {
                if current != parent.right {
                    current = parent.right
                    break
                } else {
                    current = parent
                }
            } else {
                current = nil
                break
            }
        }
        if current != nil {
            while current is SnailFishPair {
                current = (current as! SnailFishPair).left
            }
            (current as! SnailFishValue).value += (right as! SnailFishValue).value
        }
        let newNode = SnailFishValue(value: 0)
        newNode.parent = parent
        if side == .left {
            parent?.left = newNode
            newNode.side = .left
        } else {
            parent?.right = newNode
            newNode.side = .right
        }
    }
    
}
