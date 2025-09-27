//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise `nil`.
    ///
    /// - Parameter index: The index of the element to access.
    /// - Returns: The element at the given index if it exists; otherwise, `nil`.
    ///
    subscript(safe index: Index) -> Iterator.Element? {
        if index >= startIndex, index < endIndex {
            return self[index]
        } else {
            return nil
        }
    }
}
