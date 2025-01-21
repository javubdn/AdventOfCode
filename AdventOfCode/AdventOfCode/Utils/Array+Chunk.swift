//
//  Array+Chunk.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 8/3/22.
//

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
