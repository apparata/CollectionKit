//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation

extension Array {
    
    public mutating func transformFirst<T: Equatable>(where keyPath: KeyPath<Element, T>, equals value: T, using transform: (Element) -> Element) {
        guard let index = firstIndex(where: keyPath, equals: value) else {
            return
        }
        self[index] = transform(self[index])
    }

    public mutating func transformingFirst<T: Equatable>(where keyPath: KeyPath<Element, T>, equals value: T, using transform: (Element) -> Element) -> Self {
        var array = self
        array.transformFirst(where: keyPath, equals: value, using: transform)
        return array
    }
}
