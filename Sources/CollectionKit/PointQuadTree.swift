//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct PointQuadTreeBounds<T> {
    public let x0: Double
    public let y0: Double
    public let x1: Double
    public let y1: Double
    
    public init(x0: Double, y0: Double, x1: Double, y1: Double) {
        self.x0 = x0
        self.y0 = y0
        self.x1 = x1
        self.y1 = y1
    }
    
    public func contains(_ point: PointQuadTreePoint<T>) -> Bool {
        return x0 <= point.x && point.x <= x1 && y0 <= point.y && point.y <= y1
    }
    
    public func intersects(_ bounds: PointQuadTreeBounds) -> Bool {
        return x0 <= bounds.x1 && x1 >= bounds.x0 && y0 <= bounds.y1 && y1 >= bounds.y0
    }
}

public class PointQuadTreePoint<T> {
    public let x: Double
    public let y: Double
    public let context: T
    
    public init(x: Double, y: Double, context: T) {
        self.x = x
        self.y = y
        self.context = context
    }
}

public final class PointQuadTreeNode<T> {

    public let nodeCapacity = 8

    public var points: [PointQuadTreePoint<T>] = []
    
    public let bounds: PointQuadTreeBounds<T>
    
    public var northEast: PointQuadTreeNode? = nil
    public var northWest: PointQuadTreeNode? = nil
    public var southEast: PointQuadTreeNode? = nil
    public var southWest: PointQuadTreeNode? = nil
    
    public var isLeaf: Bool {
        return northEast == nil
    }
    
    public init(bounds: PointQuadTreeBounds<T>) {
        self.bounds = bounds
    }
    
    public func subdivide() {
        let x = 0.5 * (bounds.x0 + bounds.x1)
        let y = 0.5 * (bounds.y0 + bounds.y1)
        northEast = PointQuadTreeNode(bounds: PointQuadTreeBounds(x0: x, y0: bounds.y0, x1: bounds.x1, y1: y))
        northWest = PointQuadTreeNode(bounds: PointQuadTreeBounds(x0: bounds.x0, y0: bounds.y0, x1: x, y1: y))
        southEast = PointQuadTreeNode(bounds: PointQuadTreeBounds(x0: x, y0: y, x1: bounds.x1, y1: bounds.y1))
        southWest = PointQuadTreeNode(bounds: PointQuadTreeBounds(x0: bounds.x0, y0: y, x1: x, y1: bounds.y1))
    }
    
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

public class PointQuadTree<T> {
    
    public let rootNode: PointQuadTreeNode<T>
    
    public init(bounds: PointQuadTreeBounds<T>) {
        rootNode = PointQuadTreeNode<T>(bounds: bounds)
    }
    
    public func insert(_ point: PointQuadTreePoint<T>) -> Bool {
        return rootNode.insert(point)
    }
    
    public func enumeratePoints(_ action: (_ point: PointQuadTreePoint<T>) -> Void) {
        enumeratePoints(in: rootNode.bounds, node: rootNode, action: action)
    }
    
    public func enumeratePoints(in bounds: PointQuadTreeBounds<T>, action: (_ point: PointQuadTreePoint<T>) -> Void) {
        enumeratePoints(in: bounds, node: rootNode, action: action)
    }
    
    private func enumeratePoints(in bounds: PointQuadTreeBounds<T>, node: PointQuadTreeNode<T>, action: (_ point: PointQuadTreePoint<T>) -> Void) {
        guard node.bounds.intersects(bounds) else {
            return
        }
        
        for point in node.points {
            if bounds.contains(point) {
                action(point)
            }
        }
        
        if node.isLeaf { return }
        
        enumeratePoints(in: bounds, node: node.northEast!, action: action)
        enumeratePoints(in: bounds, node: node.northWest!, action: action)
        enumeratePoints(in: bounds, node: node.southEast!, action: action)
        enumeratePoints(in: bounds, node: node.southWest!, action: action)
    }
}
