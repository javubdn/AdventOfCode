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
    
}
