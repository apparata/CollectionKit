//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Array {

    /// Returns a tuple containing the first element of the array and the remaining elements as a new array.
    ///
    /// The returned tuple contains the optional first element (`nil` if the array is empty)
    /// and the remaining array.
    ///
    func splittingOffFirst() -> (Element?, [Element]) {
        return (first, Array(dropFirst()))
    }
}
