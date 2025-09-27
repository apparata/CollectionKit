//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Sequence {

    /// Returns the number of elements in the sequence that satisfy the given condition.
    ///
    /// - Parameter condition: A closure that takes an element of the sequence as its argument
    ///             and returns a Boolean value indicating whether the element should be counted.
    /// - Returns: The number of elements in the sequence that satisfy the condition.
    /// - Throws: Rethrows any error thrown by the `condition` closure.
    ///
    func count(where condition: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for element in self {
            if try condition(element) {
                count += 1
            }
        }
        return count
    }
}
