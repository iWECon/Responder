//
//  Responder.swift
//
//
//  Created by iWw on 2020/12/15.
//

import UIKit

public struct ResponderKeys {
    fileprivate static var designatedResponder = "ResponderKeys.designatedResponder"
    public static var nextResponder = "ResponderKeys.nextResponder"
}

public protocol Responder {
    var nextResponder: Responder? { get }
}

extension UIResponder: Responder {
    public var nextResponder: Responder? {
        get {
            (objc_getAssociatedObject(self, &ResponderKeys.nextResponder) as? Responder) ?? next
        }
        set {
            objc_setAssociatedObject(self, &ResponderKeys.nextResponder, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

public extension Responder {
    
    var designatedResponder: Responder? {
        get {
            objc_getAssociatedObject(self, &ResponderKeys.designatedResponder) as? Responder
        }
        nonmutating set {
            objc_setAssociatedObject(self, &ResponderKeys.designatedResponder, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    // dispatch func 适用于指定响应类和方法，用于替代 delegate
    // 适用于绝大多数使用场景
    func dispatch<T>(func: (T) -> (ResponderParam?) -> (), param: NonnullParam? = nil, initiate: Bool = true) {
        var paramsValue = param?.values ?? [:]
        if (initiate) {
            paramsValue["__source"] = self
        }
        if respondIfPossible(func: `func`, param: paramsValue) {
            return
        }
        (designatedResponder ?? nextResponder)?.dispatch(
            func: `func`,
            param: NonnullParam(values: paramsValue),
            initiate: false)
    }
    fileprivate func respondIfPossible<T>(func: (T) -> (ResponderParam?) -> (), param: ResponderParam?) -> Bool {
        guard let responder = self as? T else { return false }
        `func`(responder)(param)
        return true
    }
    
    // dispatch event 适用于不确定响应类或者有定制响应链需求的情况
    // 主要适用于通用控件
    func dispatch(event identifier: String, param: NonnullParam? = nil, initiate: Bool = true) {
        var paramsValue = param?.values ?? [:]
        if (initiate) {
            paramsValue["__source"] = self
        }
        if respondIfPossible(provider: self, identifier: identifier, param: paramsValue) {
            return
        }
        
        (designatedResponder ?? nextResponder)?.dispatch(
            event: identifier,
            param: NonnullParam(values: paramsValue),
            initiate: false)
    }
    
    fileprivate func respondIfPossible(provider: Any, identifier: String, param: ResponderParam?) -> Bool {
        let mirror = Mirror(reflecting: provider)
        for child in mirror.children {
            
            guard let Respondable = child.value as? _Respondable,
                  Respondable.isRespondable(with: provider) else {
                continue
            }
            
            guard (Respondable.identifier ?? child.label?.substring(fromIndex: 1)) == identifier else {
                continue
            }
            
            return Respondable.doRespond(with: provider, param: param)
        }
        return false
    }
}


extension String {
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }
    
    subscript(r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)), upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
}
