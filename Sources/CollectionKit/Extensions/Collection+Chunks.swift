//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Collection where Index == Int {

    /// Splits the collection into consecutive chunks of the given size.
    ///
    /// - Parameter size: The size of each chunk. Must be greater than 0.
    /// - Returns: An array of arrays, where each subarray contains up to `size` elements.
    /// 
    func chunks(of size: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, self.count)])
        }
    }
}
