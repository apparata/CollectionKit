//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Sequence {

    /// Returns the last element of the sequence that satisfies the given condition.
    ///
    /// - Parameter condition: A closure that takes an element of the sequence as its argument
    ///             and returns a Boolean value indicating whether the element satisfies the condition.
    /// - Returns: The last element of the sequence that satisfies `condition`,
    ///            or `nil` if no such element exists.
    /// - Throws: An error thrown by the `condition` closure.
    ///
    func last(where condition: (Element) throws -> Bool) rethrows -> Element? {
        for element in reversed() {
            if try condition(element) {
                return element
            }
        }
        return nil
    }

    /// Returns the last element in the sequence whose property at the given key path equals
    /// the specified value, or `nil` if no such element exists.
    ///
    /// - Parameter keyPath: A key path to a property of the element to compare.
    /// - Parameter value: The value to compare against the element's property.
    /// - Returns: The last element whose property at the key path equals the specified value,
    ///            or `nil` if none is found.
    ///
    func last<T: Equatable>(where keyPath: KeyPath<Element, T>, equals value: T) -> Element? {
        last(where: { $0[keyPath: keyPath] == value })
    }
}
