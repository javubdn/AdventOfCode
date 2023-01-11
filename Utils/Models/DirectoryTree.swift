//
//  DirectoryTree.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 29/12/22.
//

protocol DirectoryTree {
    var size: Int { get }
    var parent: Directory? {get set}
    func setParent(_ parent: Directory?)
}

class Directory: DirectoryTree {
    let name: String
    var size: Int {
        children.map { $0.size }.reduce(0, +)
    }
    var children: [DirectoryTree] = []
    var parent: Directory?
    
    init(_ name: String, parent: Directory? = nil) {
        self.name = name
        self.parent = parent
    }
    
    func add(_ item: DirectoryTree) {
        children.append(item)
        item.setParent(self)
    }
    
}

}
