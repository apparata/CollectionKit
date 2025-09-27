//
//  Copyright © 2022 Apparata AB. All rights reserved.
//

import Foundation

/// Convenience initializer that uses an `ArrayBuilder` result builder to construct the array.
///
/// - Parameter arrayBuilder: A closure marked with the `@ArrayBuilder` attribute that produces the elements for the new array.
public extension Array {
    /// Creates a new array by evaluating the provided `arrayBuilder` closure.
    ///
    /// Use this initializer to build arrays with declarative syntax powered by the `ArrayBuilder` result builder.
    ///
    /// - Parameter arrayBuilder: A closure that returns the elements to include in the array.
    init(@ArrayBuilder<Element> _ arrayBuilder: () -> [Element]) {
        self.init(arrayBuilder())
    }
}

/// A result builder that assembles arrays of `Element` from declarative blocks.
///
/// `ArrayBuilder` enables concise, DSL-like syntax for producing `[Element]`, supporting conditionals,
/// optionals, and loops via the standard result-builder building blocks.
@resultBuilder
public struct ArrayBuilder<Element> {

    /// Builds an empty array for an empty block.
    ///
    /// - Returns: An empty array.
    public static func buildBlock() -> [Element] {
        []
    }

    /// Builds the initial partial result from a single element.
    ///
    /// - Parameter first: The first element in the builder block.
    /// - Returns: An array containing `first`.
    public static func buildPartialBlock(first: Element) -> [Element] {
        [first]
    }

    /// Builds the initial partial result from an existing array of elements.
    ///
    /// - Parameter first: The initial array.
    /// - Returns: The `first` array unchanged.
    public static func buildPartialBlock(first: [Element]) -> [Element] {
        first
    }

    /// Appends a single element to the accumulated partial result.
    ///
    /// - Parameters:
    ///   - accumulated: The elements built so far.
    ///   - next: The element to append.
    /// - Returns: A new array consisting of `accumulated` followed by `next`.
    public static func buildPartialBlock(accumulated: [Element], next: Element) -> [Element] {
        accumulated + [next]
    }

    /// Concatenates the next partial array with the accumulated partial result.
    ///
    /// - Parameters:
    ///   - accumulated: The elements built so far.
    ///   - next: The next array of elements to append.
    /// - Returns: A new array consisting of `accumulated` followed by `next`.
    public static func buildPartialBlock(accumulated: [Element], next: [Element]) -> [Element] {
        accumulated + next
    }

    /// Builds an empty initial partial result for statements that produce `Void`.
    ///
    /// - Returns: An empty array.
    public static func buildPartialBlock(first: Void) -> [Element] {
        []
    }

    /// Unreachable overload that satisfies result-builder typing for statements that cannot return.
    ///
    /// This overload is used by the compiler for control-flow that never produces a value (e.g., `fatalError`).
    /// - Returns: This function does not return at runtime.
    public static func buildPartialBlock(first: Never) -> [Element] {
        //
    }

    /// Conditionally includes the given elements when they are non-`nil`.
    ///
    /// - Parameter element: An optional array of elements to include.
    /// - Returns: `element` if it is non-`nil`; otherwise, an empty array.
    public static func buildIf(_ element: [Element]?) -> [Element] {
        element ?? []
    }

    /// Builds the result for the `true` branch of a conditional.
    ///
    /// - Parameter first: The elements produced by the `true` branch.
    /// - Returns: The `first` array unchanged.
    public static func buildEither(first: [Element]) -> [Element] {
        first
    }

    /// Builds the result for the `false` branch of a conditional.
    ///
    /// - Parameter second: The elements produced by the `false` branch.
    /// - Returns: The `second` array unchanged.
    public static func buildEither(second: [Element]) -> [Element] {
        second
    }

    /// Flattens an array of partial results into a single array.
    ///
    /// Use this for building results from loops that yield multiple partial arrays.
    /// - Parameter components: The collection of partial arrays to concatenate.
    /// - Returns: A single array containing all elements of `components` in order.
    public static func buildArray(_ components: [[Element]]) -> [Element] {
        components.flatMap { $0 }
    }
}
