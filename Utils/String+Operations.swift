//
//  String+Operations.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 8/12/21.
//

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

extension String {
    
    static func add(_ item1: String, _ item2: String) -> String {
        var set = Set<Character>()
        return String((item1 + item2).filter{ set.insert($0).inserted }.sorted())
    }
    
    private func MD5() -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = data(using:.utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
    
    func MD5String() -> String {
        MD5().map { String(format: "%02hhx", $0) }.joined()
    }
    
    func splitInHalf() -> (first: String, second: String) {
        (first: String(prefix(count/2)), second: String(suffix(count/2)))
    }
    
}

extension StringProtocol {
    var asciiValues: [UInt8] { compactMap(\.asciiValue) }
}
