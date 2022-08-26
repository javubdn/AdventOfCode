//
//  Cup.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 25/8/22.
//

import Foundation

class Cup {
    
    let value: Int
    var next: Cup!
    
    init(value: Int) {
        self.value = value
    }
    
    func nextAsList(_ n: Int) -> [Cup] {
        var nextCup = next!
        var items = [nextCup]
        for _ in 1..<n {
            nextCup = nextCup.next
            items.append(nextCup)
        }
        return items
    }
    
    func valueFromMe() -> String {
        var current = next!
        var result = ""
        while current.value != value {
            result += String(current.value)
            current = current.next
        }
        return result
    }
    
}

class Cups {
    let cups: [Cup]
    var currentCup: Cup
    
    init(_ cups: [Cup], _ currentCup: Cup) {
        self.cups = cups
        self.currentCup = currentCup
    }
    
    convenience init(from input: String, numberCups: Int? = 9) {
        var cups = input.map { Cup(value: Int(String($0))!) }
        if let numberCups = numberCups, numberCups > cups.count {
            cups += Array(input.count+1...numberCups).map { Cup(value: $0) }
        }
        let currentCup = cups[0]
        for index in 1..<cups.count {
            cups[index-1].next = cups[index]
        }
        cups[cups.count-1].next = currentCup
        cups = cups.sorted { $0.value < $1.value }
        self.init(cups, currentCup)
    }
    
    func playRounds(_ numRounds: Int) -> Cup {
        for _ in 1...numRounds {
            playRound()
        }
        return cups[0]
    }
    
    func playRound() {
        let next3 = currentCup.nextAsList(3)
        let destination = calculateDestination(Set(next3.map { $0.value }))
        moveCups(next3, destination)
        currentCup = currentCup.next
    }
    
    private func calculateDestination(_ exempt: Set<Int>) -> Cup {
        var dest = currentCup.value - 1
        while exempt.contains(dest) || dest == 0 {
            dest = dest == 0 ? cups.count : dest - 1
        }
        return cups[dest-1]
    }
    
    private func moveCups(_ cupsToInsert: [Cup], _ destination: Cup) {
        let prevDest = destination.next
        currentCup.next = cupsToInsert.last!.next
        destination.next = cupsToInsert.first!
        cupsToInsert.last!.next = prevDest
    }
    
}
