//
//  Optionalable.swift
//  
//
//  Created by iWw on 2020/12/15.
//

import UIKit

protocol Optionalable: ExpressibleByNilLiteral {
    associatedtype Wrapped
    
    var wrapped: Wrapped? { get }
    
    init(_ some: Wrapped)
}

extension Optional: Optionalable {
    
    public var wrapped: Wrapped? {
        switch self {
        case .some(let wrapped):
            return wrapped
        case .none:
            return nil
        }
    }
}
