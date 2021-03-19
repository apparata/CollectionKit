//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Array {
    
    @discardableResult
    mutating func removeFirst(where condition: (Element) throws -> Bool) rethrows -> Element? {
        if let index = try firstIndex(where: condition) {
            return remove(at: index)
        }
        return nil
    }
    
    @discardableResult
    mutating func removeFirst<T: Equatable>(where keyPath: KeyPath<Element, T>, equals value: T) -> Element? {
        if let index = firstIndex(where: { $0[keyPath: keyPath] == value }) {
            return remove(at: index)
        }
        return nil
    }
}
