//
//  HomeRouter.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/25/23.
//

import Foundation

protocol HomeRouterInput {
    
    func showDetailsScreen(amount: Int, source: RateViewModel, taget: RateViewModel)
    
}

class HomeRouter: BaseModuleRouter, HomeRouterInput  {
    
    typealias TransitionHandler = HomeViewController
    var transitionHandler: HomeViewController?
    
    required init(handler: HomeViewController) {
        self.transitionHandler = handler
    }
    
    func showDetailsScreen(amount: Int, source: RateViewModel, taget: RateViewModel) {
        let detailsVc = DetailsAssembly.viewModule(amount: amount, source: source, target: taget)
        self.transitionHandler?.pushModuleInterface(controller: detailsVc, animated: true)
    }
    
}


