//
//  SandMap.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 19/1/23.
//

private struct ActionQueue: Hashable {
    let x: Int
    let y: Int
}

class SandMap {
    fileprivate var rock: Set<Position> = []
    fileprivate var sand: Set<Position> = []
    private var minX: Int
    private var minY: Int
    private var maxX: Int
    private var maxY: Int
    private var queue: Set<ActionQueue> = []
}
