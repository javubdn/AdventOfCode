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

}
