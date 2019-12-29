//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Collection where Index == Int {

    func firstIndex(where condition: (Element) throws -> Bool) rethrows -> Index? {
        for (index, value) in lazy.enumerated() {
            if try condition(value) {
                return index
            }
        }
        return nil
    }

    func lastIndex(where condition: (Element) throws -> Bool) rethrows -> Index? {
        for (index, value) in lazy.enumerated().reversed() {
            if try condition(value) {
                return index
            }
        }
        return nil
    }

    func indices(where condition: (Element) throws -> Bool) rethrows -> [Index] {
        var indices: [Index] = []
        for (index, value) in lazy.enumerated() {
            if try condition(value) {
                indices.append(index)
            }
        }
        return indices
    }
}

public extension Collection where Element: Equatable, Index == Int {
    
    func firstIndex(of item: Element) -> Index? {
        for (index, value) in lazy.enumerated() {
            if value == item {
                return index
            }
        }
        return nil
    }
    
    func lastIndex(of item: Element) -> Index? {
        for (index, value) in lazy.enumerated().reversed() {
            if value == item {
                return index
            }
        }
        return nil
    }
    
    func indices(of item: Element) -> [Index] {
        var indices: [Index] = []
        for (index, value) in lazy.enumerated() {
            if value == item {
                indices.append(index)
            }
        }
        return indices
    }
}
