//
//  DetailsPresenter.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/28/23.
//

import Foundation

protocol DetailsPresenterInput: BaseModulePresenterInput {
    func showSucessScreen(total: String, rate: String)
}

protocol DetailsPresenterOutput: BaseModulePresenterOutput { }


// MARK: - DetailsPresenter

class DetailsPresenter: BaseModulePresenter {
    
    typealias UserInterface = DetailsPresenterOutput
    weak var userInterface: UserInterface?
    
    typealias Interactor = DetailsInteractorInput
    var interactor: Interactor?
    
    typealias Router = DetailsRouterInput
    var router: Router?
    
    required init(userInterface: UserInterface) {
        self.userInterface = userInterface
    }
    
}


// MARK: - DetailsPresenterInput

extension DetailsPresenter: DetailsPresenterInput {
    func showSucessScreen(total: String, rate: String) {
        self.router?.showSucessScreen(total: total, rate: rate)
    }
}


// MARK: - DetailsInteractorOutput

extension DetailsPresenter: DetailsInteractorOutput { }
