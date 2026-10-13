
import Foundation

extension String {
    
    static func add(_ item1: String, _ item2: String) -> String {
        var set = Set<Character>()
        return String((item1 + item2).filter{ set.insert($0).inserted }.sorted())
    }
    
    private func MD5() -> Data {
    }
    
    
}

