//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Collection {
    
    subscript(safe index: Index) -> Iterator.Element? {
        if index >= startIndex, index < endIndex {
            return self[index]
        } else {
            return nil
        }
    }
}
