//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Collection where Element: BinaryInteger {
    
    /// Average of the elements in the sequence
    var average: Double {
        if isEmpty {
            return 0
        } else {
            return Double(reduce(0, +)) / Double(count)
        }
    }
}

public extension Collection where Element: FloatingPoint {

    /// Average of the elements in the sequence
    var average: Element {
        if isEmpty {
            return 0
        } else {
            return reduce(0, +) / Element(count)
        }
    }
}
