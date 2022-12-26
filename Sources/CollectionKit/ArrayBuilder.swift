//
//  Copyright © 2022 Apparata AB. All rights reserved.
//

import Foundation

public extension Array {
    init(@ArrayBuilder<Element> _ arrayBuilder: () -> [Element]) {
        self.init(arrayBuilder())
    }
}

@resultBuilder
public struct ArrayBuilder<Element> {
    
    public static func buildBlock() -> [Element] {
        []
    }
    
    public static func buildPartialBlock(first: Element) -> [Element] {
        [first]
    }
    
    public static func buildPartialBlock(first: [Element]) -> [Element] {
        first
    }
    
    public static func buildPartialBlock(accumulated: [Element], next: Element) -> [Element] {
        accumulated + [next]
    }
    
    public static func buildPartialBlock(accumulated: [Element], next: [Element]) -> [Element] {
        accumulated + next
    }
    
    public static func buildPartialBlock(first: Void) -> [Element] {
        []
    }
    
    public static func buildPartialBlock(first: Never) -> [Element] {
        //
    }
    
    public static func buildIf(_ element: [Element]?) -> [Element] {
        element ?? []
    }
    
    public static func buildEither(first: [Element]) -> [Element] {
        first
    }
    
    public static func buildEither(second: [Element]) -> [Element] {
        second
    }
    
    public static func buildArray(_ components: [[Element]]) -> [Element] {
        components.flatMap { $0 }
    }
}
