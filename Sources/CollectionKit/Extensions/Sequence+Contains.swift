//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Sequence {
        
    func containsOnly(where condition: (Element) throws -> Bool) rethrows -> Bool {
        for element in self {
            if try !condition(element) {
                return false
            }
        }
        return true
    }

    func containsNone(where condition: (Element) throws -> Bool) rethrows -> Bool {
        for element in self {
            if try condition(element) {
                return false
            }
        }
        return true
    }
}

public extension Sequence where Element: Equatable {
        
    func containsAny(of candidates: [Element]) -> Bool {
        for element in self {
            if candidates.contains(where: { (candidate: Element) -> Bool in
                element == candidate
            }) {
                return true
            }
        }
        return false
    }

    func containsAll(of candidates: [Element]) -> Bool {
        for candidate in candidates {
            guard contains(candidate) else {
                return false
            }
        }
        return true
    }
}
