//
//  Typealias.swift
//  
//
//  Created by iWw on 2020/12/15.
//

import UIKit


// For PropertyWrappers -> ResponderChain
public typealias ResponderParam = Dictionary<String, Any>
public typealias RespondableHandler = (ResponderParam?) -> Void
public typealias RespondableHandlerProvider<ClassType> = (ClassType) -> RespondableHandler
