//
//  PackageTree.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 13/1/23.
//

import Foundation

class PackageTree {
    
    var value: Int?
    var packages: [PackageTree]?
    
    init(value: Int?, packages: [PackageTree]?) {
        self.value = value
        self.packages = packages
    }
    
    convenience init(_ input: String) {
        var item = input
        var values: [PackageTree] = []
        var currentValue = 0
        var thereisValue = false
        while !item.isEmpty {
            let currentLetter = item.removeFirst()
            switch currentLetter {
            case "[":
                let package = PackageTree(value: nil, packages: [])
                values.append(package)
            case "]":
                if thereisValue {
                    let package = PackageTree(value: currentValue, packages: nil)
                    if values.last!.packages == nil { values.last!.packages = [] }
                    values.last!.packages!.append(package)
                    currentValue = 0
                    thereisValue = false
                }
                guard values.count > 1 else {
                    break
                }
                let lastPackage = values.removeLast()
                values.last!.packages!.append(lastPackage)
            case ",":
                if thereisValue {
                    let package = PackageTree(value: currentValue, packages: nil)
                    values.last!.packages!.append(package)
                    currentValue = 0
                    thereisValue = false
                }
            default: currentValue = currentValue * 10 + Int(String(currentLetter))!
                thereisValue = true
            }
        }
        self.init(value: nil, packages: values.first!.packages)
    }
    
    func correctOrder(_ second: PackageTree) -> Int {
        if let firstItem = value, let secondItem = second.value {
            return firstItem < secondItem ? 0 : firstItem > secondItem ? 1 : 2
        }
        if let firstItem = packages, let secondItem = second.packages {
            var index = 0
            while index < firstItem.count {
                guard index < secondItem.count else { return 1 }
                let currentItemOrder = firstItem[index].correctOrder(secondItem[index])
                if currentItemOrder != 2 { return currentItemOrder }
                index += 1
            }
            return 0
        }
        if let firstItem = value {
            return PackageTree(value: nil, packages: [PackageTree(value: firstItem, packages: nil)]).correctOrder(second)
        }
        return correctOrder(PackageTree(value: nil, packages: [PackageTree(value: second.value!, packages: nil)]))
    }
    
}

extension PackageTree: Equatable {
    
    static func == (lhs: PackageTree, rhs: PackageTree) -> Bool {
        if let firstItem = lhs.value, let secondItem = rhs.value {
            return firstItem == secondItem
        }
        if let firstItem = lhs.packages, let secondItem = rhs.packages {
            guard firstItem.count == secondItem.count else { return false }
            var index = 0
            while index < firstItem.count {
                let currentItemOrder = firstItem[index] == secondItem[index]
                if !currentItemOrder { return false }
                index += 1
            }
            return true
        }
        return false
    }
    
}
