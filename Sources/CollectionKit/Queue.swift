//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

/// A generic value type queue that stores elements in a first-in, first-out (FIFO) order.
///
/// The `Queue` struct provides efficient enqueue and dequeue operations, allowing you to add elements
/// to the back of the queue and remove elements from the front. This makes it suitable for scenarios where
/// you need to process elements in the order they were added.
///
/// The queue conforms to the `Sequence` protocol, so you can iterate over its elements in order.
///
/// ## FIFO Behavior
/// Elements are always removed from the front of the queue and added to the back, ensuring that
/// the first element added is the first one to be removed.
///
/// ## Usage Example
/// ```
/// var queue = Queue<Int>()
/// queue.add([7, 5, 99, 17])
/// queue.removeFirst()
/// queue.first
///
/// for value in queue {
///     print(value)
/// }
/// ```
///
public struct Queue<T> {

    fileprivate var array = Array<T>()

    /// The number of elements currently in the queue.
    public var count: Int {
        return array.count
    }

    /// A Boolean value indicating whether the queue is empty.
    public var isEmpty: Bool {
        return array.count == 0
    }

    /// The first element in the queue without removing it, or `nil` if the queue is empty.
    public var first: T? {
        return array.first
    }

    /// Creates an empty queue.
    public init() {
    }

    /// Creates a queue containing the elements of the given array in order.
    ///
    /// - Parameter array: The initial elements of the queue.
    ///
    public init(array: [T]) {
        self.array = array
    }

    /// Adds a single element to the back of the queue.
    ///
    /// - Parameter element: The element to add.
    ///
    public mutating func add(_ element: T) {
        array.append(element)
    }

    /// Adds the elements of the given sequence to the back of the queue.
    ///
    /// - Parameter sequence: A sequence of elements to add.
    ///
    public mutating func add<S: Sequence>(contentsOf sequence: S) where S.Iterator.Element == T {
        array.append(contentsOf: sequence)
    }

    /// Adds the given elements to the back of the queue.
    ///
    /// - Parameter elements: One or more elements to add.
    ///
    public mutating func add(elements: T...) {
        array.append(contentsOf: elements)
    }

    /// Removes and returns the first element of the queue.
    ///
    /// - Returns: The removed element, or `nil` if the queue is empty.
    ///
    public mutating func remove() -> T? {
        guard !isEmpty else {
            return nil
        }
        return array.removeFirst()
    }

    /// Removes up to the specified number of elements from the front of the queue.
    ///
    /// - Parameter count: The maximum number of elements to remove.
    /// - Returns: An array of the removed elements.
    ///
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

    /// Removes all elements from the queue.
    public mutating func clear() {
        array.removeAll()
    }
}

/// Conformance to the `Sequence` protocol, allowing iteration over the queue's elements in order.
extension Queue: Sequence {

    /// Returns an iterator over the elements of the queue.
    ///
    /// - Returns: An iterator over the queue's elements.
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

/// Conformance to `CustomStringConvertible` and `CustomDebugStringConvertible` to
/// provide textual representations of the queue.
extension Queue: CustomStringConvertible, CustomDebugStringConvertible {

    /// A textual representation of the queue.
    public var description: String {
        return array.description
    }
    /// A textual representation of the queue suitable for debugging.
    public var debugDescription: String {
        return array.description
    }
}
