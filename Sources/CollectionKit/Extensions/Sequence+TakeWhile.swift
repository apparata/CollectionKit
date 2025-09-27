//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Collection where Index == Int {

    /// Returns the elements from the start of the collection while they satisfy the given condition.
    ///
    /// This method iterates over the collection, returning elements until the condition
    /// returns `false` for the first time.
    ///
    /// - Parameter condition: A closure that takes an element of the collection as its argument
    ///             and returns a Boolean value indicating whether the element should be included.
    ///             This closure can throw an error.
    /// - Returns: An array containing the initial elements that satisfy the condition.
    /// - Throws: Rethrows any error thrown by the `condition` closure.
    /// 
    func take(while condition: (Element) throws -> Bool) rethrows -> [Element] {
        for (index, element) in lazy.enumerated() {
            if try !condition(element) {
                return Array(self[startIndex..<index])
            }
        }
        return Array(self)
    }
}
