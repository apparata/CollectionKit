//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

/// Value typed stack collection.
///
/// Example:
/// ```
/// var stack = Stack<Int>()
/// stack.push(1)
/// stack.push(-5)
/// stack.push(7)
/// stack.push(8)
/// stack.pop()
/// stack
/// var stack2 = stack
/// stack2.pop()
/// stack2
/// stack
///
/// for value in stack {
///    print(value)
/// }
///
/// for value in stack.array {
///    print(value)
/// }
///
/// var mappedArray = stack.map { $0 * 2 }
///
/// stack2.push([10, 20, 30, 40, 50])
/// ```
///
public struct Stack<T> {
    
    fileprivate var elements = Array<T>()
    
    public var array: Array<T> {
        return elements
    }
    
    public var count: Int {
        return elements.count
    }
    
    public var isEmpty: Bool {
        return elements.count == 0
    }
    
    public var top: T? {
        return peek()
    }
    
    public init() {}
    
    public mutating func push(_ element: T) {
        elements.append(element)
    }
    
    public mutating func push<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
        elements.append(contentsOf: sequence)
    }
    
    public mutating func pop() -> T? {
        return isEmpty ? nil : elements.removeLast()
    }
    
    public mutating func pop(count: Int) -> [T] {
        var popped = Array<T>()
        for _ in 0..<count {
            guard let value = pop() else {
                break
            }
            popped.append(value)
        }
        return popped
    }
    
    public func peek() -> T? {
        return elements.last
    }
}

extension Stack: Sequence {
    
    public func makeIterator() -> AnyIterator<T> {
        var i = elements.count - 1
        return AnyIterator {
            if i < 0 {
                return nil
            }
            let index = i
            i -= 1
            return self.elements[index]
        }
    }
    
}

extension Stack: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return elements.description
    }
    
    public var debugDescription: String {
        return elements.description
    }
}
