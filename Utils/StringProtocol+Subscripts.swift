//
//  StringProtocol+Subscripts.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 3/12/21.
//

extension StringProtocol {
    subscript(_ offset: Int)                     -> Element     { self[index(startIndex, offsetBy: offset)] }
    subscript(_ range: Range<Int>)               -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: ClosedRange<Int>)         -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence { prefix(range.upperBound.advanced(by: 1)) }
    subscript(_ range: PartialRangeUpTo<Int>)    -> SubSequence { prefix(range.upperBound) }
    subscript(_ range: PartialRangeFrom<Int>)    -> SubSequence { suffix(Swift.max(0, count-range.lowerBound)) }
    
    public func chunked(into size: Int) -> [String] {
        var chunks: [String] = []
        var i = startIndex
        while let nextIndex = index(i, offsetBy: size, limitedBy: endIndex) {
            chunks.append(String(self[i ..< nextIndex]))
            i = nextIndex
        }
        let finalChunk = self[i ..< endIndex]
        if finalChunk.isEmpty == false {
            chunks.append(String(finalChunk))
        }
        return chunks
    }
}
