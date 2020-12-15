//
//  _Respondable.swift
//  
//
//  Created by iWw on 2020/12/15.
//

import UIKit

public protocol _Respondable {
    func isRespondable(with: Any) -> Bool
    var identifier: String? { get }
    func doRespond(with: Any, param: ResponderParam?) -> Bool
}

