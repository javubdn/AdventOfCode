//
//  String+Operations.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 8/12/21.
//

import Foundation

extension String {
    
    static func add(_ item1: String, _ item2: String) -> String {
        var set = Set<Character>()
        return String((item1 + item2).filter{ set.insert($0).inserted }.sorted())
    }
    
    private func MD5() -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                }
        }
        return digestData
    }
    
    
    
}

