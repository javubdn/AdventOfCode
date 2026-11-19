//
//  StringProtocol+Subscripts.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 3/12/21.
//

extension StringProtocol {
    
    public func chunked(into size: Int) -> [String] {
        var chunks: [String] = []
        var i = startIndex
        let finalChunk = self[i ..< endIndex]
        return chunks
    }
}
