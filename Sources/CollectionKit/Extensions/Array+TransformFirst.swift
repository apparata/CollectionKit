//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation

extension Array {

    /// Mutates the array by applying a transform to the first element whose value at the given key path
    /// equals the provided value.
    ///
    /// - Parameters:
    ///   - keyPath: The key path to the property to compare.
    ///   - value: The value to match against the element's property.
    ///   - transform: A closure that takes the matching element and returns a transformed element.
    /// - Note: If no element matches, the array remains unchanged.
    ///
    public mutating func transformFirst<T: Equatable>(where keyPath: KeyPath<Element, T>, equals value: T, using transform: (Element) -> Element) {
        guard let index = firstIndex(where: keyPath, equals: value) else {
            return
        }
        self[index] = transform(self[index])
    }

    /// Returns a copy of the array with the transform applied to the first element whose value at the given
    /// key path equals the provided value, leaving the original array unchanged.
    ///
    /// - Parameters:
    ///   - keyPath: The key path to the property to compare.
    ///   - value: The value to match against the element's property.
    ///   - transform: A closure that takes the matching element and returns a transformed element.
    /// - Returns: A new array with the transform applied to the first matching element.
    ///
    public mutating func transformingFirst<T: Equatable>(where keyPath: KeyPath<Element, T>, equals value: T, using transform: (Element) -> Element) -> Self {
        var array = self
        array.transformFirst(where: keyPath, equals: value, using: transform)
        return array
    }
}
