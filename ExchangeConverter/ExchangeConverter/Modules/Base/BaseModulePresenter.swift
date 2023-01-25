//
//  BaseModulePresenter.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/24/23.
//

public protocol BaseModulePresenter: AnyObject {
    
    var userInterface: UserInterface? { set get }
    var interactor: Interactor? { set get }
    var router: Router? { set get }
    
    associatedtype UserInterface
    associatedtype Interactor
    associatedtype Router
    
    init(userInterface: UserInterface)
}

public protocol BaseModulePresenterInput: AnyObject { }

public protocol BaseModulePresenterOutput: AnyObject { }
