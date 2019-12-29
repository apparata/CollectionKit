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
public struct PriorityQueue<T> {
    
    private var heap: [T?] = []
    
    public private(set) var count: Int = 0
    
    private let comparator: (T, T) -> Bool
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public var first: T? {
        guard !isEmpty else {
            return nil
        }
        return heap[0]
    }
    
    public init(_ comparator: @escaping (T, T) -> Bool) {
        self.comparator = comparator
    }
    
    public init(array: [T], _ comparator: @escaping (T, T) -> Bool) {
        self.comparator = comparator
        count = array.count
        heap.append(contentsOf: array.map({ $0 }))
        for i in stride(from: (count / 2), through: 0, by: -1) {
            sink(i)
        }
    }
    
    public mutating func add(_ element: T) {
        if count > heap.count - 1 {
            heap.append(contentsOf: Array<T?>(repeating: nil, count: count + 1))
        }
        heap[count] = element
        raise(count)
        count += 1
    }
    
    public mutating func add<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
        for element in sequence {
            add(element)
        }
    }
    
    public mutating func add(elements: T...) {
        for element in elements {
            add(element)
        }
    }
    
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
