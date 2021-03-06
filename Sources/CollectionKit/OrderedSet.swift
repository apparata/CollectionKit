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

    /// Removes element based on equality.
    @discardableResult
    public mutating func remove(_ element: Element) -> Element? {
        elements.removeFirst { element == $0 }
        return set.remove(element)
    }
    
    @discardableResult
    public mutating func removeFirst() -> Element? {
        guard elements.count > 0 else {
            return nil
        }
        let element = elements.removeFirst()
        set.remove(element)
        return element
    }
    
    @discardableResult
    public mutating func removeLast() -> Element? {
        guard elements.count > 0 else {
            return nil
        }
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

extension OrderedSet: Codable where Element: Codable {
    
    enum CodingKeys: String, CodingKey {
        case elements
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let decodedElements = try container.decode([Element].self, forKey: .elements)
        elements = []
        set = Set()
        for element in decodedElements {
            let (wasInserted, _) = set.insert(element)
            if wasInserted {
                elements.append(element)
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(elements, forKey: .elements)
    }
}
