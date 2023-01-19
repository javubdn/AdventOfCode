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
    
}
