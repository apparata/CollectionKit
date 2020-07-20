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
    
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        map { element in
            element[keyPath: keyPath]
        }
    }

    func compactMap<T>(_ keyPath: KeyPath<Element, T?>) -> [T] {
        compactMap { element in
            element[keyPath: keyPath]
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
            return a[keyPath: keyPath] > b[keyPath: keyPath]
        })
    }
}
