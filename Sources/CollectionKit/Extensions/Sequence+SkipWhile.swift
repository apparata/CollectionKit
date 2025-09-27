//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Collection where Index == Int {

    /// Skips elements from the start of the collection while they satisfy the given condition,
    /// then returns the remaining elements as an array.
    ///
    /// - Parameter condition: A closure that takes an element of the collection as its argument
    ///   and returns a Boolean value indicating whether the element should be skipped.
    /// - Returns: An array containing the elements after the initial elements that satisfy the condition.
    /// - Throws: Rethrows any error thrown by the `condition` closure.
    /// 
    func skip(while condition: (Element) throws -> Bool) rethrows -> [Element] {
        for (index, element) in lazy.enumerated() {
            if try !condition(element) {
                return Array(self[index..<endIndex])
            }
        }
        return []
    }
}
