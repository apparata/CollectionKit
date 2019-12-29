//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct OrderedSet<Element: Hashable>: Equatable, Collection {
    
    public typealias Index = Int
    
    public typealias Indices = Range<Int>
    
    private var elements: [Element]
    private var set: Set<Element>
    
    public init() {
        elements = []
        set = Set()
    }
    
    public init(elements: [Element]) {
        self.init()
        for element in elements {
            append(element)
        }
    }
    
    public var count: Int {
        return elements.count
    }
    
    public var isEmpty: Bool {
        return elements.isEmpty
    }
    
    public var array: [Element] {
        return elements
    }
    
    public func contains(_ element: Element) -> Bool {
        return set.contains(element)
    }
    
    @discardableResult
    public mutating func append(_ newElement: Element) -> Bool {
        let (wasInserted, _) = set.insert(newElement)
        if wasInserted {
            elements.append(newElement)
        }
        return wasInserted
    }
    
    public mutating func removeLast() -> Element {
        let element = elements.removeLast()
        set.remove(element)
        return element
    }
    
    public mutating func removeAll(keepingCapacity: Bool = false) {
        elements.removeAll(keepingCapacity: keepingCapacity)
        set.removeAll(keepingCapacity: keepingCapacity)
    }
    
    static public func == <T>(lhs: OrderedSet<T>, rhs: OrderedSet<T>) -> Bool {
        return lhs.elements == rhs.elements
    }
}

extension OrderedSet: ExpressibleByArrayLiteral {

    public init(arrayLiteral elements: Element...) {
        self.init(elements: elements)
    }
}

extension OrderedSet: RandomAccessCollection {
    
    public var startIndex: Int {
        return elements.startIndex
    }
    
    public var endIndex: Int {
        return elements.endIndex
    }
    
    public subscript(index: Int) -> Element {
        return elements[index]
    }
}

