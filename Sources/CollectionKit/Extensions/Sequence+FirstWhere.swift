//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Sequence {

    /// Returns the first element in the sequence whose property at the given key path equals
    /// the specified value, or `nil` if no such element exists.
    ///
    /// - Parameter keyPath: A key path to a property of the element to compare.
    /// - Parameter value: The value to compare against the element's property.
    /// - Returns: The first element whose property at the key path equals the specified value,
    ///            or `nil` if none is found.
    ///            
    func first<T: Equatable>(where keyPath: KeyPath<Element, T>, equals value: T) -> Element? {
        first(where: { $0[keyPath: keyPath] == value })
    }
}
