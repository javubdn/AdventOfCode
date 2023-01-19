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
//                if values.last!.packages == nil { values.last!.packages = [] }
                values.last!.packages!.append(lastPackage)
            case ",":
                if thereisValue {
                    let package = PackageTree(value: currentValue, packages: nil)
//                    if values.last!.packages == nil { values.last!.packages = [] }
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
    
}
