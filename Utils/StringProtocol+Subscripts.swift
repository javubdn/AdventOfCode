//
//  StringProtocol+Subscripts.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 3/12/21.
//

extension StringProtocol {
    subscript(_ range: PartialRangeFrom<Int>)    -> SubSequence { suffix(Swift.max(0, count-range.lowerBound)) }
    
    public func chunked(into size: Int) -> [String] {
        var chunks: [String] = []
        var i = startIndex
        let finalChunk = self[i ..< endIndex]
        return chunks
    }
}
