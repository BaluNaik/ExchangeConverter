//
//  HomePresenter.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/25/23.
//

import Foundation

protocol HomePresenterInput: BaseModulePresenterInput {
    var currentBase: String? { get }
    
    func eventLoadData(for base: String?,
                         completion:@escaping (_ errorMsg: String?) -> ())
    func getCurrencyCodes(for type: CurrentTextField) -> [String]
    func calculateAmount(amount: Int, currency: String)
}

protocol HomePresenterOutput: BaseModulePresenterOutput {
    func showErrorAlert(errorMsg: String)
}


// MARK: - HomePresenter

class HomePresenter: BaseModulePresenter {
    
    typealias UserInterface = HomePresenterOutput
    weak var userInterface: UserInterface?
    
    typealias Interactor = HomeInteractorInput
    var interactor: Interactor?
    
    typealias Router = HomeRouterInput
    var router: Router?
    
    required init(userInterface: UserInterface) {
        self.userInterface = userInterface
    }
    
}


// MARK: - HomeInteractorOutput

extension HomePresenter: HomeInteractorOutput { }


// MARK: - HomePresenterInput

extension HomePresenter: HomePresenterInput {
    var currentBase: String? {
        return interactor?.currentBase
    }
    
    func eventLoadData(for base: String?, completion:@escaping (_ errorMsg: String?) -> ()) {
        interactor?.eventLoadData(for: base, completion: completion)
    }
    
    func getCurrencyCodes(for type: CurrentTextField) -> [String] {
        
        return interactor?.getCurrencyCodes(for: type) ?? []
    }
    
    func calculateAmount(amount: Int, currency: String) {
        interactor?.getTransferDetails(for: currency, completion: { source, target in
            if let target = target {
                self.router?.showDetailsScreen(amount: amount, source: source, taget: target)
            } else {
                self.userInterface?.showErrorAlert(errorMsg: APIError.storageError.localizedDescription)
            }
        })
    }
    
}
