//
//  BaseModuleInteractor.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/24/23.
//

import Foundation

public protocol BaseModuleInteractor: AnyObject {

    var presenter: Presenter? { set get }
    
    associatedtype Presenter
    init(presenter: Presenter)
}

public protocol BaseModuleInteractorInput: AnyObject { }

public protocol BaseModuleInteractorOutput: AnyObject { }
