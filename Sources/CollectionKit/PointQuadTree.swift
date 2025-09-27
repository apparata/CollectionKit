//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

/// An axis-aligned rectangular region used to bound points in a `PointQuadTree`.
///
/// The bounds are defined by two corner coordinates `(x0, y0)` and `(x1, y1)`.
///
public struct PointQuadTreeBounds<T> {

    /// The minimum x-coordinate of the rectangle.
    public let x0: Double

    /// The minimum y-coordinate of the rectangle.
    public let y0: Double

    /// The maximum x-coordinate of the rectangle.
    public let x1: Double

    /// The maximum y-coordinate of the rectangle.
    public let y1: Double

    /// Creates a new rectangular bounds.
    ///
    /// - Parameters:
    ///   - x0: The minimum x-coordinate.
    ///   - y0: The minimum y-coordinate.
    ///   - x1: The maximum x-coordinate.
    ///   - y1: The maximum y-coordinate.
    ///
    public init(x0: Double, y0: Double, x1: Double, y1: Double) {
        self.x0 = x0
        self.y0 = y0
        self.x1 = x1
        self.y1 = y1
    }

    /// Returns a Boolean value indicating whether these bounds contain the specified point.
    ///
    /// Points on the edges are considered contained.
    ///
    /// - Parameter point: The point to test.
    /// - Returns: `true` if `point` lies within or on the edges of the bounds; otherwise, `false`.
    ///
    public func contains(_ point: PointQuadTreePoint<T>) -> Bool {
        return x0 <= point.x && point.x <= x1 && y0 <= point.y && point.y <= y1
    }

    /// Returns a Boolean value indicating whether these bounds intersect the given bounds.
    ///
    /// - Parameter bounds: The other bounds to test for intersection.
    /// - Returns: `true` if the two rectangles overlap or touch; otherwise, `false`.
    ///
    public func intersects(_ bounds: PointQuadTreeBounds) -> Bool {
        return x0 <= bounds.x1 && x1 >= bounds.x0 && y0 <= bounds.y1 && y1 >= bounds.y0
    }
}

/// A point stored in a `PointQuadTree`, carrying a context value of type `T`.
public class PointQuadTreePoint<T> {

    /// The x-coordinate of the point.
    public let x: Double

    /// The y-coordinate of the point.
    public let y: Double

    /// Arbitrary context associated with the point.
    public let context: T

    /// Creates a point with the given coordinates and context.
    ///
    /// - Parameters:
    ///   - x: The x-coordinate.
    ///   - y: The y-coordinate.
    ///   - context: The context value to associate with the point.
    ///
    public init(x: Double, y: Double, context: T) {
        self.x = x
        self.y = y
        self.context = context
    }
}

/// A node in a point quadtree, holding up to `nodeCapacity` points and up to four child nodes.
public final class PointQuadTreeNode<T> {

    /// The maximum number of points a leaf node can store before it subdivides.
    public let nodeCapacity = 8

    /// The points stored directly in this node.
    public var points: [PointQuadTreePoint<T>] = []

    /// The rectangular region covered by this node.
    public let bounds: PointQuadTreeBounds<T>

    /// The northeast child node, created upon subdivision.
    public var northEast: PointQuadTreeNode? = nil

    /// The northwest child node, created upon subdivision.
    public var northWest: PointQuadTreeNode? = nil

    /// The southeast child node, created upon subdivision.
    public var southEast: PointQuadTreeNode? = nil

    /// The southwest child node, created upon subdivision.
    public var southWest: PointQuadTreeNode? = nil

    /// A Boolean value indicating whether this node has no children.
    public var isLeaf: Bool {
        return northEast == nil
            && northWest == nil
            && southEast == nil
            && southWest == nil
    }

    /// Creates a quadtree node with the specified bounds.
    ///
    /// - Parameter bounds: The rectangular region covered by the node.
    ///
    public init(bounds: PointQuadTreeBounds<T>) {
        self.bounds = bounds
    }

    /// Splits this node into four child quadrants and distributes subsequent insertions among them.
    public func subdivide() {
        let x = 0.5 * (bounds.x0 + bounds.x1)
        let y = 0.5 * (bounds.y0 + bounds.y1)
        northEast = PointQuadTreeNode(bounds: PointQuadTreeBounds(x0: x, y0: bounds.y0, x1: bounds.x1, y1: y))
        northWest = PointQuadTreeNode(bounds: PointQuadTreeBounds(x0: bounds.x0, y0: bounds.y0, x1: x, y1: y))
        southEast = PointQuadTreeNode(bounds: PointQuadTreeBounds(x0: x, y0: y, x1: bounds.x1, y1: bounds.y1))
        southWest = PointQuadTreeNode(bounds: PointQuadTreeBounds(x0: bounds.x0, y0: y, x1: x, y1: bounds.y1))
    }

    /// Inserts a point into this node or its descendants.
    ///
    /// - Parameter point: The point to insert.
    /// - Returns: `true` if the point was inserted;
    ///            otherwise, `false` (e.g., when outside the node bounds).
    ///
    public func insert(_ point: PointQuadTreePoint<T>) -> Bool {
        guard bounds.contains(point) else {
            return false
        }

        if points.count < nodeCapacity {
            points.append(point)
            return true
        }

        if isLeaf {
            subdivide()
        }

        return northEast!.insert(point)
        || northWest!.insert(point)
        || southEast!.insert(point)
        || southWest!.insert(point)
    }
}

/// A point quadtree for efficient spatial indexing and querying of 2D points with associated context.
public class PointQuadTree<T> {

    /// The root node of the quadtree.
    public let rootNode: PointQuadTreeNode<T>

    /// Creates a quadtree covering the given bounds.
    ///
    /// - Parameter bounds: The rectangular area covered by the quadtree.
    ///
    public init(bounds: PointQuadTreeBounds<T>) {
        rootNode = PointQuadTreeNode<T>(bounds: bounds)
    }

    /// Inserts a point into the quadtree.
    ///
    /// - Parameter point: The point to insert.
    /// - Returns: `true` if the point was inserted; otherwise, `false`.
    ///
    public func insert(_ point: PointQuadTreePoint<T>) -> Bool {
        return rootNode.insert(point)
    }

    /// Enumerates all points in the quadtree and invokes the given closure for each.
    ///
    /// - Parameter action: A closure called once for each stored point.
    ///
    public func enumeratePoints(_ action: (_ point: PointQuadTreePoint<T>) -> Void) {
        enumeratePoints(in: rootNode.bounds, node: rootNode, action: action)
    }

    /// Enumerates all points within the specified bounds and invokes the given closure for each.
    ///
    /// - Parameters:
    ///   - bounds: The rectangular region to query.
    ///   - action: A closure called for each point contained in `bounds`.
    ///
    public func enumeratePoints(in bounds: PointQuadTreeBounds<T>, action: (_ point: PointQuadTreePoint<T>) -> Void) {
        enumeratePoints(in: bounds, node: rootNode, action: action)
    }

    private func enumeratePoints(
        in bounds: PointQuadTreeBounds<T>,
        node: PointQuadTreeNode<T>,
        action: (_ point: PointQuadTreePoint<T>) -> Void
    ) {
        guard node.bounds.intersects(bounds) else {
            return
        }

        for point in node.points {
            if bounds.contains(point) {
                action(point)
            }
        }

        if node.isLeaf { return }

        let children = [
            node.northEast,
            node.northWest,
            node.southEast,
            node.southWest
        ].compactMap { $0 }

        for child in children {
            enumeratePoints(in: bounds, node: child, action: action)
        }
    }
}
