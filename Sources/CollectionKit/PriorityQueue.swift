//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

/// Generic priority queue. Element priority is determined by comparator.
///
/// Example:
///
/// ```
/// var queue = PriorityQueue<Int>(>)
/// queue.add([7, 5, 99, 17])
/// queue.removeFirst()
/// queue.first
///
/// var queue2 = PriorityQueue<Int>(<)
/// queue2.add([1, 2, 100, 3])
/// queue2.removeFirst()
/// queue2.first
///
/// var queue3 = PriorityQueue<String>(array: ["12", "1", "1234", "123"]) {
///     $0.characters.count < $1.characters.count
/// }
/// queue3.removeFirst()
/// queue3.first
/// ```
///
/// A generic priority queue backed by a binary heap.
///
/// The queue orders elements using the provided `comparator`. Higher-priority elements (as defined by
/// the comparator) will be dequeued first.
///
public struct PriorityQueue<T> {

    private var heap: [T?] = []

    /// The number of elements currently stored in the queue.
    public private(set) var count: Int = 0

    private let comparator: (T, T) -> Bool

    /// A Boolean value indicating whether the queue has no elements.
    public var isEmpty: Bool {
        return count == 0
    }

    /// The highest-priority element without removing it, or `nil` if the queue is empty.
    public var first: T? {
        guard !isEmpty else {
            return nil
        }
        return heap[0]
    }

    /// Creates an empty priority queue with the given comparator.
    ///
    /// - Parameter comparator: A closure that returns `true` if its first argument should be
    ///                         ordered before its second argument.
    ///                         Use `>` for a max-heap and `<` for a min-heap.
    ///
    public init(_ comparator: @escaping (T, T) -> Bool) {
        self.comparator = comparator
    }

    /// Creates a priority queue from an initial array of elements and a comparator.
    ///
    /// The resulting heap contains all elements reordered according to heap semantics.
    ///
    /// - Parameters:
    ///   - array: The initial elements to insert into the queue.
    ///   - comparator: A closure that returns `true` if its first argument should be ordered
    ///                 before its second argument.
    ///
    public init(array: [T], _ comparator: @escaping (T, T) -> Bool) {
        self.comparator = comparator
        count = array.count
        heap.append(contentsOf: array.map({ $0 }))
        for i in stride(from: (count / 2), through: 0, by: -1) {
            sink(i)
        }
    }

    /// Inserts a single element into the queue.
    ///
    /// - Parameter element: The element to insert.
    ///
    public mutating func add(_ element: T) {
        if count > heap.count - 1 {
            heap.append(contentsOf: Array<T?>(repeating: nil, count: count + 1))
        }
        heap[count] = element
        raise(count)
        count += 1
    }

    /// Inserts all elements from the given sequence into the queue.
    ///
    /// - Parameter sequence: A sequence of elements to insert.
    ///
    public mutating func add<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
        for element in sequence {
            add(element)
        }
    }

    /// Inserts all provided elements into the queue.
    ///
    /// - Parameter elements: The elements to insert.
    ///
    public mutating func add(elements: T...) {
        for element in elements {
            add(element)
        }
    }

    /// Removes and returns the highest-priority element.
    ///
    /// - Returns: The removed element, or `nil` if the queue is empty.
    ///
    public mutating func removeFirst() -> T? {
        guard let element = first else {
            return nil
        }
        count -= 1
        heap[0] = heap[count]
        heap[count] = nil
        if count <= heap.count / 4 {
            heap.removeSubrange(heap.count / 2 ..< heap.count)
        }
        sink(0)
        return element
    }

    private mutating func raise(_ index: Int) {
        var currentIndex = index
        var parentIndex = parent(currentIndex)
        while currentIndex > 0 && greater(currentIndex, parentIndex) {
            let currentValue = self.heap[currentIndex]
            let parentValue = self.heap[parentIndex]
            self.heap[currentIndex] = parentValue
            self.heap[parentIndex] = currentValue
            currentIndex = parentIndex
            parentIndex = self.parent(currentIndex)
        }
    }

    private mutating func sink(_ index: Int) {
        var currentIndex = index
        var child = minChild(currentIndex)
        while child != -1 && greater(child, currentIndex) {
            let currentValue = heap[currentIndex]
            let childValue = heap[child]
            heap[currentIndex] = childValue
            heap[child] = currentValue
            currentIndex = child
            child = minChild(currentIndex)
        }
    }

    private func parent(_ index: Int) -> Int {
        return (index - 1) / 2
    }

    private func minChild(_ parentIndex: Int)  -> Int {
        let leftChildIndex = parentIndex * 2 + 1
        let rightChildIndex = leftChildIndex + 1
        if leftChildIndex >= count {
            return -1
        }
        if rightChildIndex >= count {
            return leftChildIndex
        }
        if greater(leftChildIndex, rightChildIndex) {
            return leftChildIndex
        } else {
            return rightChildIndex
        }
    }

    private func greater(_ a: Int, _ b: Int) -> Bool {
        return self.comparator(self.heap[a]!, self.heap[b]!)
    }
}
