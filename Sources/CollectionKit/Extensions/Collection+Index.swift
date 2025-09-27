//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Collection where Index == Int {

    /// Returns the index of the first element that satisfies the given condition.
    ///
    /// - Parameter condition: A closure that takes an element of the collection as its argument and
    ///                        returns a Boolean value indicating whether the element is a match.
    /// - Returns: The index of the first element that satisfies `condition`,
    ///            or `nil` if there is no element that satisfies `condition`.
    /// - Throws: Rethrows any error thrown by the `condition` closure.
    ///
    func firstIndex(where condition: (Element) throws -> Bool) rethrows -> Index? {
        for (index, value) in lazy.enumerated() {
            if try condition(value) {
                return index
            }
        }
        return nil
    }

    /// Returns the index of the last element that satisfies the given condition.
    ///
    /// - Parameter condition: A closure that takes an element of the collection as its argument and
    ///                        returns a Boolean value indicating whether the element is a match.
    /// - Returns: The index of the last element that satisfies `condition`,
    ///            or `nil` if there is no element that satisfies `condition`.
    /// - Throws: Rethrows any error thrown by the `condition` closure.
    ///
    func lastIndex(where condition: (Element) throws -> Bool) rethrows -> Index? {
        for (index, value) in lazy.enumerated().reversed() {
            if try condition(value) {
                return index
            }
        }
        return nil
    }

    /// Returns an array of indices for all elements that satisfy the given condition.
    ///
    /// - Parameter condition: A closure that takes an element of the collection as its argument and
    ///                        returns a Boolean value indicating whether the element is a match.
    /// - Returns: An array of indices for all elements that satisfy `condition`.
    /// - Throws: Rethrows any error thrown by the `condition` closure.
    ///
    func indices(where condition: (Element) throws -> Bool) rethrows -> [Index] {
        var indices: [Index] = []
        for (index, value) in lazy.enumerated() {
            if try condition(value) {
                indices.append(index)
            }
        }
        return indices
    }
}

public extension Collection {

    /// Returns the index of the first element where the property at the given key path equals
    /// the specified value.
    ///
    /// **Example:**
    ///
    /// ```
    /// func index(of cover: Cover) -> Int? {
    ///     return covers.firstIndex(where: \.id, equals: cover.id)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - keyPath: A key path to a property of the element.
    ///   - value: The value to compare against the property at `keyPath`.
    /// - Returns: The index of the first element where the property at `keyPath` equals `value`,
    ///            or `nil` if no such element is found.
    ///
    func firstIndex<T: Equatable>(where keyPath: KeyPath<Element, T>, equals value: T) -> Index? {
        return firstIndex(where: { $0[keyPath: keyPath] == value })
    }
}

public extension Collection where Element: Equatable, Index == Int {

    /// Returns the index of the first occurrence of the given element.
    ///
    /// - Parameter item: The element to find.
    /// - Returns: The index of the first occurrence of `item`, or `nil` if `item` is not found.
    ///
    func firstIndex(of item: Element) -> Index? {
        for (index, value) in lazy.enumerated() {
            if value == item {
                return index
            }
        }
        return nil
    }

    /// Returns the index of the last occurrence of the given element.
    ///
    /// - Parameter item: The element to find.
    /// - Returns: The index of the last occurrence of `item`, or `nil` if `item` is not found.
    ///
    func lastIndex(of item: Element) -> Index? {
        for (index, value) in lazy.enumerated().reversed() {
            if value == item {
                return index
            }
        }
        return nil
    }

    /// Returns an array of indices for all occurrences of the given element.
    ///
    /// - Parameter item: The element to find.
    /// - Returns: An array of indices for all occurrences of `item`.
    ///
    func indices(of item: Element) -> [Index] {
        var indices: [Index] = []
        for (index, value) in lazy.enumerated() {
            if value == item {
                indices.append(index)
            }
        }
        return indices
    }
}
