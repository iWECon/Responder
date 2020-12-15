//
//  NonnullParam.swift
//  
//
//  Created by iWw on 2020/12/15.
//

import UIKit

public struct NonnullParam {
    
    public var values: [String: Any]
    
    public init(values: [String: Any?]) {
        self.values = values.compactMapValues({ $0 })
    }
    
    public subscript(key: String) -> Any? {
        get {
            values[key]
        }
        set {
            values[key] = newValue
        }
    }
    
    public subscript<T>(key: String, type: T.Type) -> T? {
        get {
            values[key] as? T
        }
    }
}

extension NonnullParam: Equatable {
    public static func == (lhs: NonnullParam, rhs: NonnullParam) -> Bool {
        NSDictionary(dictionary: lhs.values).isEqual(to: rhs.values)
    }
}

extension NonnullParam: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, Any?)...) {
        var values: [String: Any?] = [:]
        for (key, value) in elements {
            values[key] = value
        }
        self.init(values: values)
    }
}

public extension ResponderParam {
    var source: Any? {
        return self["__source"]
    }
}
