//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

/// A stack of snapshot values with undo/redo functionality.
///
/// The `Snapshot` generic type **must** be a value type.
///
public final class SnapshotStack<Snapshot> {

    /// Maximum undo capacity of the stack. If a snapshot is added when the stack has reached
    /// the maximum capactity, the snapshot element at the bottom of the stack will be removed.
    public let maxUndoLevels: Int

    /// Returns `true` if there are snapshots below the current snapshot in the stack.
    public var canUndo: Bool {
        return cursor > 0
    }

    /// Returns `true` if there are snapshots above the current snapshot in the stack.
    public var canRedo: Bool {
        return cursor < stack.count - 1
    }

    /// Returns the snapshot that is currently pointed to by the internal undo/redo cursor.
    public var currentSnapshot: Snapshot {
        return stack[cursor]
    }

    /// The snapshots contained in the stack.
    public private(set) var stack: [Snapshot] = []

    private var cursor: Int = -1

    /// Initialize the snapshot stack with an initial snapshot and the maximum number of undo levels.
    ///
    /// - Parameter initialSnapshot: The initial snapshot at the bottom of the stack.
    /// - Parameter maxUndoLevels: The maximum of undo levels in the stack.
    public init(initialSnapshot: Snapshot, maxUndoLevels: UInt) {
        self.maxUndoLevels = Int(max(maxUndoLevels, 1))
        self.addSnapshot(initialSnapshot)
    }

    /// Add a snapshot to the top of the stack.
    ///
    /// If the undo/redo cursor is not pointing to the top element on the stack,
    /// all redo snapshots above the cursor's current position are discarded
    /// before the new snapshot is added.
    ///
    /// - Parameter snapshot: The snapshot to add to the top of the stack.
    public func addSnapshot(_ snapshot: Snapshot) {

        if canRedo {
            // If we have redos, we should discard them
            // before adding a new snapshot.
            stack.removeSubrange((cursor + 1)...)
        }
        stack.append(snapshot)
        if stack.count > maxUndoLevels {
            stack.removeFirst()
        }
        cursor = stack.count - 1
    }

    /// Move the undo/redo cursor down one step in the stack, if there is at least one snapshot below
    /// the current cursor position, i.e. if `canUndo` is `true`. Otherwise, has no effect.
    public func undo() {
        if canUndo {
            cursor -= 1
        }
    }

    /// Move the undo/redo cursor up one step in the stack, if there is at least one snapshot above
    /// the current cursor position, i.e. if `canRedo` is `true`. Otherwise, has no effect.
    public func redo() {
        if canRedo {
            cursor += 1
        }
    }

    /// Remove all snapshots from the stack.
    public func clear() {
        stack.removeAll()
        cursor = -1
    }
}

// If the snapshots in the undo stack are codable,
// then the undo stack is codable.
extension SnapshotStack: Codable where Snapshot: Codable { }

// If the `Snapshot` type is `Equatable`, new snapshots will not be added
// if they equate the current snapshot.
extension SnapshotStack where Snapshot: Equatable {

    /// Add a snapshot to the top of the stack. If the snapshot is equal to the current snapshot
    /// the snapshot will not be added.
    ///
    /// If the undo/redo cursor is not pointing to the top element on the stack,
    /// all redo snapshots above the cursor's current position are discarded
    /// before the new snapshot is added.
    ///
    /// - Parameter snapshot: The snapshot to add to the top of the stack.
    public func addSnapshot(_ snapshot: Snapshot) {

        // Don't add snapshot if it is identical.
        guard snapshot != currentSnapshot else {
            return
        }

        if canRedo {
            // If we have redos, we should discard them
            // before adding a new snapshot.
            stack.removeSubrange((cursor + 1)...)
        }
        stack.append(snapshot)
        if stack.count > maxUndoLevels {
            stack.removeFirst()
        }
        cursor = stack.count - 1
    }
}
