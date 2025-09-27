//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

/// A compact set of bits backed by a byte array.
///
/// `BitSet` lets you set and query individual bit positions using zero-based indices.
/// Bits are stored in little-endian order within each byte (bit 0 is the least-significant bit).
/// 
public struct BitSet {

    private var bytes: [UInt8] = []

    /// Creates an empty bit set with no bits set.
    public init() {
        bytes = []
    }

    /// Creates a bit set and sets the specified bit indices.
    ///
    /// - Parameter bitsToSet: The zero-based indices of the bits to set initially.
    ///                        Duplicates are ignored.
    ///
    public init(bitsToSet: [Int]) {

        self.init()

        // Find the highest bit index in the set
        let highestBitIndex = bitsToSet.max() ?? 0

        expandIfNecessaryToAccomodateBit(at: highestBitIndex)

        // Set the bits in the bytes array
        for bit in bitsToSet {
            let byteIndex = bit / 8
            let bitPositinInByte = bit % 8
            bytes[byteIndex] |= UInt8(1 << bitPositinInByte)
        }
    }

    /// Returns the underlying byte representation of the bit set.
    ///
    /// - Returns: An array of bytes where each bit corresponds to a bit position in the set.
    ///
    public func asBytes() -> [UInt8] {
        return bytes
    }

    /// Sets the bit at the specified index to `1`.
    ///
    /// The storage expands as needed to accommodate the given index.
    ///
    /// - Parameter index: The zero-based bit index to set.
    ///
    public mutating func setBit(at index: Int) {
        expandIfNecessaryToAccomodateBit(at: index)

        let byteIndex = index / 8
        let bitPositinInByte = index % 8
        bytes[byteIndex] |= UInt8(1 << bitPositinInByte)
    }

    /// Clears the bit at the specified index (sets it to `0`).
    ///
    /// The storage expands as needed to accommodate the given index.
    ///
    /// - Parameter index: The zero-based bit index to clear.
    ///
    public mutating func clearBit(at index: Int) {
        expandIfNecessaryToAccomodateBit(at: index)

        let byteIndex = index / 8
        let bitPositinInByte = index % 8
        bytes[byteIndex] &= ~UInt8(1 << bitPositinInByte)
    }

    /// Returns a Boolean value indicating whether the bit at the specified index is set.
    ///
    /// If the index is beyond the current storage, this returns `false`.
    ///
    /// - Parameter index: The zero-based bit index to query.
    /// - Returns: `true` if the bit is set; otherwise, `false`.
    ///
    public func isBitSet(at index: Int) -> Bool {
        let byteIndex = index / 8
        let bitPositinInByte = index % 8
        guard byteIndex < bytes.count else {
            return false
        }
        return (bytes[byteIndex] & UInt8(1 << bitPositinInByte)) != 0
    }

    /// Accesses the bit at the specified index using subscript syntax.
    ///
    /// Use this subscript to get or set the value of a bit at a given index.
    ///
    /// - Parameter index: The zero-based index of the bit to access.
    /// - Returns: `true` if the bit at the specified index is set; otherwise, `false`.
    ///
    /// Assigning `true` to this subscript sets the bit at the specified index.
    /// Assigning `false` clears the bit at the specified index.
    ///
    public subscript(index: Int) -> Bool {
        get {
            return isBitSet(at: index)
        }
        set {
            if newValue {
                setBit(at: index)
            } else {
                clearBit(at: index)
            }
        }
    }

    private mutating func expandIfNecessaryToAccomodateBit(at index: Int) {
        let byteCount = BitSet.byteCountForBitSet(highestBitIndex: index)
        if byteCount > bytes.count {
            bytes.append(contentsOf: Array(repeating: 0, count: byteCount))
        }
    }

    /// Calculate how many bytes are needed to represent all the bits.
    private static func byteCountForBitSet(highestBitIndex: Int) -> Int {
        return highestBitIndex / 8 + 1
    }

}
