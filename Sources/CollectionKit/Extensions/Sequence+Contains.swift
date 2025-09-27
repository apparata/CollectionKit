//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Sequence {

    /// Returns `true` if all elements in the sequence satisfy the given condition.
    ///
    /// - Parameter condition: A closure that takes an element of the sequence as its argument
    ///             and returns a Boolean value indicating whether the element satisfies the condition.
    /// - Returns: `true` if all elements satisfy the condition; otherwise, `false`.
    /// - Throws: Rethrows any error thrown by the `condition` closure.
    ///
    func containsOnly(where condition: (Element) throws -> Bool) rethrows -> Bool {
        for element in self {
            if try !condition(element) {
                return false
            }
        }
        return true
    }

    /// Returns `true` if none of the elements in the sequence satisfy the given condition.
    ///
    /// - Parameter condition: A closure that takes an element of the sequence as its argument
    ///             and returns a Boolean value indicating whether the element satisfies the condition.
    /// - Returns: `true` if none of the elements satisfy the condition; otherwise, `false`.
    /// - Throws: Rethrows any error thrown by the `condition` closure.
    ///
    func containsNone(where condition: (Element) throws -> Bool) rethrows -> Bool {
        for element in self {
            if try condition(element) {
                return false
            }
        }
        return true
    }
}

public extension Sequence where Element: Equatable {

    /// Returns `true` if the sequence contains at least one of the given candidate elements.
    ///
    /// - Parameter candidates: An array of elements to search for in the sequence.
    /// - Returns: `true` if the sequence contains at least one of the candidates; otherwise, `false`.
    ///
    func containsAny(of candidates: [Element]) -> Bool {
        for element in self {
            if candidates.contains(where: { (candidate: Element) -> Bool in
                element == candidate
            }) {
                return true
            }
        }
        return false
    }

    /// Returns `true` if the sequence contains all of the given candidate elements.
    ///
    /// - Parameter candidates: An array of elements to check for presence in the sequence.
    /// - Returns: `true` if the sequence contains all of the candidates; otherwise, `false`.
    ///
    func containsAll(of candidates: [Element]) -> Bool {
        for candidate in candidates {
            guard contains(candidate) else {
                return false
            }
        }
        return true
    }
}
