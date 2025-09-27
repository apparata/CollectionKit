//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

/// A value-typed stack collection that stores elements in a last-in, first-out (LIFO) order.
///
/// Provides efficient `push`, `pop`, and `peek` operations. The stack conforms to `Sequence`,
/// allowing iteration from the top element down to the bottom.
///
/// ## Example
/// 
/// ```swift
/// var stack = Stack<Int>()
/// stack.push(1)
/// stack.push(-5)
/// stack.push(7)
/// stack.push(8)
/// stack.pop()
///
/// var stack2 = stack
/// stack2.pop()
///
/// for value in stack {
///    print(value)
/// }
///
/// for value in stack.array {
///    print(value)
/// }
///
/// let mappedArray = stack.map { $0 * 2 }
///
/// stack2.push([10, 20, 30, 40, 50])
/// ```
///
public struct Stack<T> {

    fileprivate var elements = Array<T>()

    /// The contents of the stack as an array, with the bottom element first and the top element last.
    public var array: Array<T> {
        return elements
    }

    /// The number of elements currently in the stack.
    public var count: Int {
        return elements.count
    }

    /// A Boolean value indicating whether the stack is empty.
    public var isEmpty: Bool {
        return elements.count == 0
    }

    /// The element at the top of the stack without removing it, or `nil` if the stack is empty.
    public var top: T? {
        return peek()
    }

    /// Creates an empty stack.
    public init() {}

    /// Pushes a single element onto the top of the stack.
    ///
    /// - Parameter element: The element to add.
    public mutating func push(_ element: T) {
        elements.append(element)
    }

    /// Pushes the elements of the given sequence onto the stack in order.
    ///
    /// - Parameter sequence: A sequence of elements to add.
    ///   The first element of the sequence will end up below the later elements.
    public mutating func push<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
        elements.append(contentsOf: sequence)
    }

    /// Removes and returns the top element of the stack.
    ///
    /// - Returns: The removed element, or `nil` if the stack is empty.
    public mutating func pop() -> T? {
        return isEmpty ? nil : elements.removeLast()
    }

    /// Removes up to the specified number of elements from the top of the stack.
    ///
    /// - Parameter count: The maximum number of elements to remove.
    /// - Returns: An array of the removed elements, starting with the most recently pushed.
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

    /// Returns the element at the top of the stack without removing it.
    ///
    /// - Returns: The top element, or `nil` if the stack is empty.
    public func peek() -> T? {
        return elements.last
    }
}

/// Conformance to the `Sequence` protocol, enabling iteration over the stack's elements
/// from the top element down to the bottom.
extension Stack: Sequence {

    /// Returns an iterator over the elements of the stack, starting from the top.
    ///
    /// - Returns: An iterator that yields elements from top to bottom.
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

/// Conformance to `CustomStringConvertible` and `CustomDebugStringConvertible` to provide textual representations of the stack.
extension Stack: CustomStringConvertible, CustomDebugStringConvertible {
    /// A textual representation of the stack's elements.
    public var description: String {
        return elements.description
    }

    /// A textual representation of the stack's elements, suitable for debugging.
    public var debugDescription: String {
        return elements.description
    }
}
