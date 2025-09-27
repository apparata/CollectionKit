//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Sequence {

    /// Returns the elements whose value at the given key path satisfies the provided condition.
    ///
    /// - Parameters:
    ///   - keyPath: The key path to the value to test on each element.
    ///   - condition: A closure that takes the value at the given key path and returns a Boolean
    ///                value indicating whether the element should be included.
    /// - Returns: An array of elements whose value at the key path satisfies the condition.
    ///
    func filter<T>(by keyPath: KeyPath<Element, T>, where condition: (T) -> Bool) -> [Element] {
        filter { element in
            let value = element[keyPath: keyPath]
            return condition(value)
        }
    }

    /// Returns the elements of the sequence, sorted by the value at the given key path.
    ///
    /// - Parameter keyPath: The key path to the value to sort by.
    /// - Returns: An array of the sorted elements.
    ///
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { a, b in
            return a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }

    /// Groups the elements of the sequence into a dictionary, keyed by the value at the given key path.
    ///
    /// - Parameter keyPath: The key path to the value to group by.
    /// - Returns: A dictionary where each key is a value at the key path and the value is
    ///            an array of elements with that key.
    ///
    func group<Key: Hashable>(by keyPath: KeyPath<Element, Key>) -> [Key: [Element]] {
        Dictionary(grouping: self) { (element) -> Key in
            return element[keyPath: keyPath]
        }
    }

    /// Creates a dictionary with keys from the value at the given key path and values as
    /// the elements themselves.
    ///
    /// - Parameter keyPath: The key path to the value to use as the dictionary key.
    /// - Returns: A dictionary mapping the value at the key path to the corresponding element.
    ///
    func dictionary<Key: Hashable>(keyedBy keyPath: KeyPath<Element, Key>) -> [Key: Element] {
        reduce(into: [:]) { $0[$1[keyPath: keyPath]] = $1 }
    }

    /// Returns the element with the smallest value at the given key path, or nil if the sequence is empty.
    ///
    /// - Parameter keyPath: The key path to the value to compare.
    /// - Returns: The element with the minimum value at the key path, or nil if the sequence is empty.
    ///
    func min<T: Comparable>(by keyPath: KeyPath<Element, T>) -> Element? {
        self.min(by: { a, b in
            return a[keyPath: keyPath] < b[keyPath: keyPath]
        })
    }

    /// Returns the element with the largest value at the given key path, or nil if the sequence is empty.
    ///
    /// - Parameter keyPath: The key path to the value to compare.
    /// - Returns: The element with the maximum value at the key path, or nil if the sequence is empty.
    ///
    func max<T: Comparable>(by keyPath: KeyPath<Element, T>) -> Element? {
        self.max(by: { a, b in
            return a[keyPath: keyPath] < b[keyPath: keyPath]
        })
    }

    /// Returns true if all elements have `true` at the given Boolean key path.
    ///
    /// - Parameter keyPath: The key path to the Boolean value.
    /// - Returns: `true` if all elements have `true` at the key path, otherwise `false`.
    ///
    func allAreTrue(_ keyPath: KeyPath<Element, Bool>) -> Bool {
        allSatisfy { $0[keyPath: keyPath] }
    }

    /// Returns true if at least one element has `true` at the given Boolean key path.
    ///
    /// - Parameter keyPath: The key path to the Boolean value.
    /// - Returns: `true` if at least one element has `true` at the key path, otherwise `false`.
    ///
    func anyIsTrue(_ keyPath: KeyPath<Element, Bool>) -> Bool {
        contains { $0[keyPath: keyPath] }
    }

    /// Returns true if all elements have `false` at the given Boolean key path.
    ///
    /// - Parameter keyPath: The key path to the Boolean value.
    /// - Returns: `true` if all elements have `false` at the key path, otherwise `false`.
    ///
    func noneAreTrue(_ keyPath: KeyPath<Element, Bool>) -> Bool {
        allSatisfy { $0[keyPath: keyPath] == false }
    }
}
