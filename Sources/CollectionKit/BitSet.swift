//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct BitSet {
    
    private var bytes: [UInt8] = []
    
    public init() {
        bytes = []
    }
    
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
    
    public func asBytes() -> [UInt8] {
        return bytes
    }
    
    public mutating func setBit(at index: Int) {
        expandIfNecessaryToAccomodateBit(at: index)
        
        let byteIndex = index / 8
        let bitPositinInByte = index % 8
        bytes[byteIndex] |= UInt8(1 << bitPositinInByte)
    }
    
    public func isBitSet(at index: Int) -> Bool {
        let byteIndex = index / 8
        let bitPositinInByte = index % 8
        guard byteIndex < bytes.count else {
            return false
        }
        return (bytes[byteIndex] & UInt8(1 << bitPositinInByte)) != 0
    }
    
    public subscript(index: Int) -> Bool {
        get {
            return isBitSet(at: index)
        }
        set {
            setBit(at: index)
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
