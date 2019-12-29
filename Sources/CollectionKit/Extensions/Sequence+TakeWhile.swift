//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Collection where Index == Int {
    
    func take(while condition: (Element) throws -> Bool) rethrows -> [Element] {
        for (index, element) in lazy.enumerated() {
            if try !condition(element) {
                return Array(self[startIndex..<index])
            }
        }
        return Array(self)
    }
}
