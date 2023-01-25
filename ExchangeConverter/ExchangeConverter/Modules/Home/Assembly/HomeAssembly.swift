//
//  HomeWireframe.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/24/23.
//

import UIKit

class HomeAssembly {
    
    static var viewController: HomeViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        ModuleBuilder(root: vc)
        return vc
    }
}

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

