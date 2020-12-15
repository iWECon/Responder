//
//  Respondable.swift
//  
//
//  Created by iWw on 2020/12/15.
//

import UIKit

@propertyWrapper
public class Respondable<T>: _Respondable {
    
    public var identifier: String?
    private var handler: RespondableHandlerProvider<T>?
    
    public init(wrappedValue: RespondableHandlerProvider<T>?) {
        self.handler = wrappedValue
    }
    
    public init(wrappedValue: RespondableHandlerProvider<T>?, _ identifier: String) {
        self.identifier = identifier
        self.handler = wrappedValue
    }
    
    public var wrappedValue: RespondableHandlerProvider<T>? {
        get {
            handler
        }
        set {
            handler = newValue
        }
    }
    
    public func isRespondable(with: Any) -> Bool {
        return with is T
    }
    
    public func doRespond(with: Any, param: ResponderParam?) -> Bool {
        guard let handler = handler,
              let with = with as? T else { return false }
        handler(with)(param)
        return true
    }
}

