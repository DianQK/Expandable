//
//  SafeCollection.swift
//  Expandable
//
//  Created by 宋宋 on 8/18/16.
//  Copyright © 2016 T. All rights reserved.
//

import Foundation

public struct SafeCollection<Base : CollectionType>: CollectionType {
    
    private var _base: Base
    public init(_ base: Base) {
        _base = base
    }
    
    public typealias Index = Base.Index
    public var startIndex: Index {
        return _base.startIndex
    }
    
    public var endIndex: Index {
        return _base.endIndex
    }
    
    public subscript(index: Base.Index) -> Base.Generator.Element? {
        if startIndex.distanceTo(index) >= 0 && index.distanceTo(endIndex) > 0 {
            return _base[index]
        }
        return nil
    }
    
    public subscript(bounds: Range<Base.Index>) -> Base.SubSequence? {
        if startIndex.distanceTo(bounds.startIndex) >= 0 && bounds.endIndex.distanceTo(endIndex) >= 0 {
            return _base[bounds]
        }
        return nil
    }
    
    var safe: SafeCollection<Base> { //Allows to chain ".safe" without side effects
        return self
    }
}

public extension CollectionType {
    var safe: SafeCollection<Self> {
        return SafeCollection(self)
    }
}