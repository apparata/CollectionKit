//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Collection where Index == Int {

    func skip(while condition: (Element) throws -> Bool) rethrows -> [Element] {
        for (index, element) in lazy.enumerated() {
            if try !condition(element) {
                return Array(self[index..<endIndex])
            }
        }
        return []
    }
}
