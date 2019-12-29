//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Sequence where Element: BinaryInteger {
    
    /// Sum of the elements in the sequence.
    var sum: Element {
        return reduce(0, +)
    }
}

public extension Sequence where Element: FloatingPoint {
    
    /// Sum of the elements in the sequence.
    var sum: Element {
        return reduce(0, +)
    }    
}
