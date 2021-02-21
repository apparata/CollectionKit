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
}
