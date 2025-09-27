//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

/// An ordered set that maintains the uniqueness of elements and their insertion order.
///
/// `OrderedSet` stores unique elements in the order they were added,
/// similar to a combination of `Array` and `Set`.
///
public struct OrderedSet<Element: Hashable>: Equatable, Collection {

    /// An index in the ordered set.
    public typealias Index = Int

    /// The indices that are valid for subscripting the ordered set.
    public typealias Indices = Range<Int>

    /// The number of elements in the ordered set.
    public var count: Int {
        return elements.count
    }

    /// A Boolean value indicating whether the ordered set is empty.
    public var isEmpty: Bool {
        return elements.isEmpty
    }

    /// The elements of the ordered set as an array, in insertion order.
    public var array: [Element] {
        return elements
    }

    /// The elements stored in insertion order.
    private var elements: [Element]
    /// The set for uniqueness checking.
    private var set: Set<Element>

    /// Creates an empty ordered set.
    public init() {
        elements = []
        set = Set()
    }

    /// Creates an ordered set with the given elements, preserving order and uniqueness.
    ///
    /// - Parameter elements: The elements to include in the set.
    ///
    public init(elements: [Element]) {
        self.init()
        for element in elements {
            append(element)
        }
    }

    /// Returns a Boolean value indicating whether the set contains the given element.
    ///
    /// - Parameter element: The element to check for membership.
    ///
    public func contains(_ element: Element) -> Bool {
        return set.contains(element)
    }

    /// Appends a new element to the ordered set if it is not already present.
    ///
    /// - Parameter newElement: The element to append.
    /// - Returns: `true` if the element was inserted, `false` if it was already present.
    ///
    @discardableResult
    public mutating func append(_ newElement: Element) -> Bool {
        let (wasInserted, _) = set.insert(newElement)
        if wasInserted {
            elements.append(newElement)
        }
        return wasInserted
    }

    /// Removes an element from the ordered set based on equality.
    ///
    /// - Parameter element: The element to remove.
    /// - Returns: The removed element if it was present, otherwise `nil`.
    @discardableResult
    public mutating func remove(_ element: Element) -> Element? {
        elements.removeFirst { element == $0 }
        return set.remove(element)
    }

    /// Removes and returns the first element of the ordered set.
    ///
    /// - Returns: The removed element, or `nil` if the set is empty.
    @discardableResult
    public mutating func removeFirst() -> Element? {
        guard elements.count > 0 else {
            return nil
        }
        let element = elements.removeFirst()
        set.remove(element)
        return element
    }

    /// Removes and returns the last element of the ordered set.
    ///
    /// - Returns: The removed element, or `nil` if the set is empty.
    @discardableResult
    public mutating func removeLast() -> Element? {
        guard elements.count > 0 else {
            return nil
        }
        let element = elements.removeLast()
        set.remove(element)
        return element
    }

    /// Removes all elements from the ordered set.
    ///
    /// - Parameter keepingCapacity: Whether to keep the underlying storage.
    ///
    public mutating func removeAll(keepingCapacity: Bool = false) {
        elements.removeAll(keepingCapacity: keepingCapacity)
        set.removeAll(keepingCapacity: keepingCapacity)
    }

    /// Returns a Boolean value indicating whether two ordered sets are equal.
    ///
    /// - Parameters:
    ///   - lhs: The first ordered set to compare.
    ///   - rhs: The second ordered set to compare.
    /// - Returns: `true` if the ordered sets contain the same elements in the same order.
    ///
    static public func == <T>(lhs: OrderedSet<T>, rhs: OrderedSet<T>) -> Bool {
        return lhs.elements == rhs.elements
    }
}

/// Conformance to `ExpressibleByArrayLiteral` to allow initialization from array literals.
extension OrderedSet: ExpressibleByArrayLiteral {

    /// Creates an ordered set from an array literal.
    ///
    /// - Parameter elements: The elements to include in the set.
    ///
    public init(arrayLiteral elements: Element...) {
        self.init(elements: elements)
    }
}

/// Conformance to `RandomAccessCollection` to support efficient random access and iteration.
extension OrderedSet: RandomAccessCollection {

    /// The position of the first element in a nonempty ordered set.
    public var startIndex: Int {
        return elements.startIndex
    }

    /// The position one past the last element in a nonempty ordered set.
    public var endIndex: Int {
        return elements.endIndex
    }

    /// Accesses the element at the specified position.
    /// - Parameter index: The position of the element to access.
    public subscript(index: Int) -> Element {
        return elements[index]
    }
}

/// Conformance to `Codable` when the element type is `Codable`.
///
/// Encodes and decodes the ordered set while preserving element uniqueness and order.
extension OrderedSet: Codable where Element: Codable {

    /// The coding keys used for encoding and decoding.
    enum CodingKeys: String, CodingKey {
        case elements
    }

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
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

    /// Encodes this value into the given encoder.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// 
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(elements, forKey: .elements)
    }
}
