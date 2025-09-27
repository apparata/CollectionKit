//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Array {

    /// Removes and returns the first element of the array that satisfies the given condition.
    ///
    /// - Parameter condition: A closure that takes an element of the array as its argument and
    ///                        returns a Boolean value indicating whether the element is a match.
    /// - Returns: The first element that satisfies the condition, or `nil` if no such element is found.
    /// - Throws: Rethrows any error thrown by the condition closure.
    @discardableResult
    mutating func removeFirst(where condition: (Element) throws -> Bool) rethrows -> Element? {
        if let index = try firstIndex(where: condition) {
            return remove(at: index)
        }
        return nil
    }

    /// Removes and returns the first element of the array where the value at the specified key path equals the given value.
    ///
    /// - Parameters:
    ///   - keyPath: A key path to a property of the element.
    ///   - value: A value to compare against the element's property.
    /// - Returns: The first element where the value at the key path equals the provided value,
    ///            or `nil` if no such element is found.
    @discardableResult
    mutating func removeFirst<T: Equatable>(where keyPath: KeyPath<Element, T>, equals value: T) -> Element? {
        if let index = firstIndex(where: { $0[keyPath: keyPath] == value }) {
            return remove(at: index)
        }
        return nil
    }
}
