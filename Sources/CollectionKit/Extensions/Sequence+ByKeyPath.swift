//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension Sequence {
    
    func filter<T>(by keyPath: KeyPath<Element, T>, where condition: (T) -> Bool) -> [Element] {
        filter { element in
            let value = element[keyPath: keyPath]
            return condition(value)
        }
    }
    
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { a, b in
            return a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
        
    func group<Key: Hashable>(by keyPath: KeyPath<Element, Key>) -> [Key: [Element]] {
        Dictionary(grouping: self) { (element) -> Key in
                return element[keyPath: keyPath]
        }
    }
    
    func dictionary<Key: Hashable>(keyedBy keyPath: KeyPath<Element, Key>) -> [Key: Element] {
        reduce(into: [:]) { $0[$1[keyPath: keyPath]] = $1 }
    }
    
    func min<T: Comparable>(by keyPath: KeyPath<Element, T>) -> Element? {
        self.min(by: { a, b in
            return a[keyPath: keyPath] < b[keyPath: keyPath]
        })
    }
    
    func max<T: Comparable>(by keyPath: KeyPath<Element, T>) -> Element? {
        self.max(by: { a, b in
            return a[keyPath: keyPath] < b[keyPath: keyPath]
        })
    }
    
    func allAreTrue(_ keyPath: KeyPath<Element, Bool>) -> Bool {
        allSatisfy { $0[keyPath: keyPath] }
    }

    func anyIsTrue(_ keyPath: KeyPath<Element, Bool>) -> Bool {
        contains { $0[keyPath: keyPath] }
    }
    
    func noneAreTrue(_ keyPath: KeyPath<Element, Bool>) -> Bool {
        allSatisfy { $0[keyPath: keyPath] == false }
    }
}
