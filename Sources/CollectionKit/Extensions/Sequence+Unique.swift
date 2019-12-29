//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

extension Sequence where Element: Hashable {
    
    public var unique: [Element] {
        let setOfUniqueElements = Set<Element>(self)
        return Array<Element>(setOfUniqueElements)
    }
}
