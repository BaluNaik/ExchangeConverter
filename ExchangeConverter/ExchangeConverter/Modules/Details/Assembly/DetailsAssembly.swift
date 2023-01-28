//
//  DetailsAssembly.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/28/23.
//

import UIKit

class DetailsAssembly {
    
    static func viewModule(amount: Int, source: RateViewModel, target: RateViewModel) -> DetailsViewController {
        let vc = DetailsViewController(amount: amount, source: source, target: target)
        ModuleBuilder(root: vc)
        return vc
    }
}


// MARK: - Private

private extension DetailsAssembly {
    
    static func ModuleBuilder(root: DetailsViewController) {
        let presenter = DetailsPresenter(userInterface: root)
        
        let interactor = DetailsInteractor(presenter: presenter)
        presenter.interactor = interactor
        
        let router = DetailsRouter(handler: root)
        presenter.router = router
        root.presenter = presenter
    }
    
}
