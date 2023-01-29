//
//  HomeWireframe.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/24/23.
//

import UIKit

class HomeAssembly {
    
    static var viewController: HomeViewController {
        let vc = HomeViewController()
        ModuleBuilder(root: vc)
        return vc
    }
}


// MARK: - Private

private extension HomeAssembly {
    
    static func ModuleBuilder(root: HomeViewController) {
        let presenter = HomePresenter(userInterface: root)
        
        let interactor = HomeInteractor(presenter: presenter)
        presenter.interactor = interactor
        
        let router = HomeRouter(handler: root)
        presenter.router = router
        root.presenter = presenter
    }
    
}
