//
//  Utils.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 27/12/21.
//

import Foundation

class Utils {
    
    static func permutations(_ array: [String]) -> [[String]] {
        let n = array.count
        var result: [[String]] = []
        guard n > 0 else { return [[]] }
        
        for i in 0..<n {
            
            let before = Array(array[0..<i])
            let after  = Array(array[i+1..<n])
            
            let lastLevel = permutations(before + after)
            
            result += lastLevel.map { $0 + [array[i]] }
        }
        
        return result
    }
    
    private static func variations<T>(elements: ArraySlice<T>, k: Int) -> [[T]] {
        if k == 0 {
            return [[]]
        }

        guard let first = elements.first else {
            return []
        }

        let subVariations: [[T]] = variations(elements: elements.dropFirst(), k: k - 1)
        var result: [[T]] = []
        subVariations.forEach { subVariation in
            for index in 0..<subVariation.count {
                var sub = subVariation
                sub.insert(first, at: index)
                result.append(sub)
            }
            var sub = subVariation
            sub.insert(first, at: subVariation.count)
            result.append(sub)
        }
        result += variations(elements: elements.dropFirst(), k: k)

        return result
    }

    static func variations<T>(elements: Array<T>, k: Int) -> [[T]] {
        return variations(elements: ArraySlice(elements), k: k)
    }
    
    private static func nonOrderedVariations<T>(elements: ArraySlice<T>, k: Int) -> [[T]] {
        if k == 0 {
            return [[]]
        }

        guard let first = elements.first else {
            return []
        }

        let subVariations: [[T]] = nonOrderedVariations(elements: elements.dropFirst(), k: k - 1)
        var result: [[T]] = []
        subVariations.forEach { subVariation in
            var sub = subVariation
            sub.insert(first, at: subVariation.count)
            result.append(sub)
        }
        result += nonOrderedVariations(elements: elements.dropFirst(), k: k)

        return result
    }
    
    static func nonOrderedVariations<T>(elements: Array<T>, k: Int) -> [[T]] {
        return nonOrderedVariations(elements: ArraySlice(elements), k: k)
    }
    
    static func combinations(_ number: Int, in parts: Int) -> [[Int]] {
        if parts == 0 { return [[Int]]() }
        if parts == 1 { return [[number]] }
        var result  = [[Int]]()
        var newNumber = number
        while newNumber > 0 {
            let subCombinations = combinations(newNumber, in: parts - 1)
            subCombinations.forEach { subCombination in
                for index in 0..<subCombination.count {
                    var sub = subCombination
                    sub.insert(number-newNumber, at: index)
                    result.append(sub)
                }
                var sub = subCombination
                sub.insert(number-newNumber, at: subCombination.count)
                result.append(sub)
            }
            newNumber -= 1
        }
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
}
