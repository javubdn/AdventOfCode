//
//  Utils.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 27/12/21.
//

import Foundation

class Utils {
    
        
        
    
    private static func variations<T>(elements: ArraySlice<T>, k: Int) -> [[T]] {
        if k == 0 {
            return [[]]
        }

        subVariations.forEach { subVariation in
            for index in 0..<subVariation.count {
                var sub = subVariation
                sub.insert(first, at: index)
                result.append(sub)
            }
            var sub = subVariation
            result.append(sub)
        }
        result += variations(elements: elements.dropFirst(), k: k)

        return result
    }

    static func variations<T>(elements: Array<T>, k: Int) -> [[T]] {
        return variations(elements: ArraySlice(elements), k: k)
    }
    
    
    static func combinations(_ number: Int, in parts: Int) -> [[Int]] {
        if parts == 0 { return [[Int]]() }
        if parts == 1 { return [[number]] }
        var result  = [[Int]]()
        return Array(Set(result))
    }
    
    static func clusters<T>(_ array: Array<T>) -> [[T]] {
        let n = array.count
        var result: [[T]] = []
        guard n > 0 else { return [[]] }
        
        let subClusters = clusters(array.dropLast())
        subClusters.forEach { item in
            result.append(item)
            result.append(item + [array.last!])
        }
        return result
    }
    
    static func countChars(_ input: String) -> [String: Int] {
        var counts: [String: Int] = [:]
        for character in input {
            if counts[String(character)] == nil { counts[String(character)] = 0 }
            counts[String(character)]! += 1
        }
        return counts
    }
    
    static func countItems<U>(_ input: [U]) -> [U: Int] {
        var counts: [U: Int] = [:]
        for item in input {
            if counts[item] == nil { counts[item] = 0 }
            counts[item]! += 1
        }
        return counts
    }
    
    static func cartesianProduct<U, V>(lhs: [U], rhs: [V]) -> [(U, V)] {
        lhs.flatMap { left in
            rhs.map { right in
                (left, right)
            }
        }
    }
    
    static func manhattanDistance(_ point1: (Int, Int), _ point2: (Int, Int)) -> Int {
        abs(point2.0 - point1.0) + abs(point2.1 - point1.1)
    }
    
    static func manhattanDistance3D(_ point1: (Int, Int, Int), _ point2: (Int, Int, Int)) -> Int {
        abs(point2.0 - point1.0) + abs(point2.1 - point1.1) + abs(point2.2 - point1.2)
    }
    
    static func isPrime(_ n: Int) -> Bool {
        guard n > 1 else { return false }
        guard n > 2 else { return true  }
        guard n % 2 != 0 else { return false }
        return !stride(from: 3, through: Int(sqrt(Double(n))), by: 2).contains { n % $0 == 0 }
    }
    
    static func firstReadingOrder(_ point1: (x: Int, y: Int), _ point2: (x: Int, y: Int)) -> Bool {
        point1.y < point2.y || ( point1.y == point2.y && point1.x < point2.x)
    }
    
    static func evaluatePerformance<T>(_ code: () -> T) -> (T, Double) {
        let start = DispatchTime.now()
        let result = code()
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        return (result, timeInterval)
    }
    
    static func intersectsSegment(_ segment: ((Int, Int), (Int, Int)),
                                  in segments: [((Int, Int), (Int, Int))],
                                  horizontal: Bool) -> [(Int, Int)] {
        var instersectItems: [(Int, Int)] = []
        for segmentFromList in segments {
        }
        return instersectItems
    }
    
    
    static func lcm(_ a: Int, _ b: Int) -> Int {
        a / gcd(a, b) * b
    }
    
    static func binarySearchBy(_ range: (Int, Int), fn: (Int) -> Int) -> Int {
        var low = range.0
        var high = range.1
        return low - 1
    }
    
}
