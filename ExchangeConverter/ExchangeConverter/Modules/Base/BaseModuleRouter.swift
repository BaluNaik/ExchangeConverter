//
//  BaseModuleRouter.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/24/23.
//

import UIKit

public protocol BaseModuleRouter: AnyObject {
    
    var transitionHandler: TransitionHandler? { set get }
    
    associatedtype TransitionHandler
    
    init(handler: TransitionHandler)
    
}
