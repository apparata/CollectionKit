# CollectionKit

A Swift package that provides a collection of useful data structures and extensions for working with collections in iOS, macOS, and tvOS applications.

## Overview

CollectionKit extends Swift's collection types with additional functionality and provides specialized data structures for common programming needs. It includes efficient implementations of sets, queues, stacks, and more, along with convenient extensions for sequence and collection operations.

## Data Structures

### BitSet
A compact set of bits backed by a byte array, perfect for efficient boolean flag storage.

```swift
var bitSet = BitSet(bitsToSet: [0, 2, 5])
bitSet.setBit(at: 7)
print(bitSet.isBitSet(at: 2)) // true
```

### OrderedSet
Maintains uniqueness of elements while preserving insertion order.

```swift
var orderedSet = OrderedSet<String>()
orderedSet.append("first")
orderedSet.append("second") 
orderedSet.append("first") // Won't be added again
print(orderedSet.array) // ["first", "second"]
```

### PriorityQueue
A binary heap-based priority queue with customizable comparison.

```swift
var queue = PriorityQueue<Int>(>)
queue.add([7, 5, 99, 17])
print(queue.removeFirst()) // 99 (highest priority)
```

### Queue & Stack
Standard FIFO queue and LIFO stack implementations.

```swift
var queue = Queue<String>()
queue.enqueue("first")
queue.enqueue("second")
print(queue.dequeue()) // "first"

var stack = Stack<Int>()
stack.push(1)
stack.push(2)
print(stack.pop()) // 2
```

### SnapshotStack
A stack that can capture and restore snapshots of its state.

### PointQuadTree
Spatial data structure for efficient 2D point storage and querying.

### ArrayBuilder
Result builder for constructing arrays with a declarative syntax.

## Collection Extensions

CollectionKit provides numerous extensions to make working with collections more convenient:

### Sequence Extensions
- `first(where:equals:)` - Find elements by key path equality
- `last(where:equals:)` - Find last element by key path equality
- `countWhere(_:)` - Count elements matching a condition
- `contains(where:equals:)` - Check existence by key path equality
- `sum()` - Sum numeric sequences
- `unique()` - Remove duplicates
- `takeWhile(_:)` - Take elements while condition is true
- `skipWhile(_:)` - Skip elements while condition is true

### Collection Extensions
- `chunks(of:)` - Split into chunks of specified size
- `average()` - Calculate average of numeric collections
- `safeIndex(_:)` - Safe index access
- `index(of:where:equals:)` - Find index by key path equality

### Array Extensions
- `removeFirst(where:)` - Remove first matching element
- `transformFirst(where:_:)` - Transform first matching element
- `splittingOffFirst(where:)` - Split array at first match

## License

CollectionKit is available under the BSD Zero Clause License. See the LICENSE file for more information.
