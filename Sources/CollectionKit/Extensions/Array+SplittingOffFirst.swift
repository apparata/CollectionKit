//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Array {
    
    func splittingOffFirst() -> (Element?, [Element]) {
        return (first, Array(dropFirst()))
    }
}
