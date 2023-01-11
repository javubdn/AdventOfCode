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
}

}
