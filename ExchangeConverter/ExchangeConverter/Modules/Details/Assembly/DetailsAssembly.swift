//
//  DetailsAssembly.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/28/23.
//

import UIKit

class DetailsAssembly {
    
    static func viewModule(conversionModel: PairConversionModel) -> DetailsViewController {
        let vc = DetailsViewController(conversionModel: conversionModel)
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
