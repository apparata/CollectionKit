//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

/// Generic value type queue.
///
/// Example:
/// ```
/// var queue = Queue<Int>()
/// queue.add([7, 5, 99, 17])
/// queue.removeFirst()
/// queue.first
///
/// for value in queue {
///    print(value)
/// }
/// ```
public struct Queue<T> {
    
    fileprivate var array = Array<T>()
    
    public var count: Int {
        return array.count
    }
    
    public var isEmpty: Bool {
        return array.count == 0
    }
    
    public var first: T? {
        return array.first
    }
    
    public init() {
    }
    
    public init(array: [T]) {
        self.array = array
    }
    
    public mutating func add(_ element: T) {
        array.append(element)
    }
    
    public mutating func add<S: Sequence>(contentsOf sequence: S) where S.Iterator.Element == T {
        array.append(contentsOf: sequence)
    }
    
    public mutating func add(elements: T...) {
        array.append(contentsOf: elements)
    }
    
    public mutating func remove() -> T? {
        guard !isEmpty else {
            return nil
        }
        return array.removeFirst()
    }
    
    public mutating func remove(count: Int) -> [T] {
        var removed = Array<T>()
        for _ in 0..<count {
            guard let value = remove() else {
                break
            }
            removed.append(value)
        }
        return removed
    }
    
    
    public mutating func clear() {
        array.removeAll()
    }
}

extension Queue: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        var i = 0
        return AnyIterator {
            if i >= self.array.count {
                return nil
            }
            let element = self.array[i]
            i += 1
            return element
        }
    }
}

extension Queue: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return array.description
    }
    
    public var debugDescription: String {
        return array.description
    }
}
