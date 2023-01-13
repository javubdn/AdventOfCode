//
//  Stack.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 29/12/22.
//

struct Stack<T> {
    var array: [T] = []
    
    mutating func push(_ element: T) {
         array.append(element)
    }
    
    mutating func push(_ elements: [T]) {
        array.append(contentsOf: elements)
    }
    
    mutating func pop() -> T? {
        guard !array.isEmpty else { return nil }
        return array.removeLast()
    }
    
    mutating func pop(_ k: Int) -> [T]? {
        guard array.count >= k else { return nil }
        let items = array.suffix(k)
        array.removeLast(k)
        return Array(items)
    }
    
    func peek() -> T? {
        guard !array.isEmpty else { return nil }
        return array.last
    }
    
}
