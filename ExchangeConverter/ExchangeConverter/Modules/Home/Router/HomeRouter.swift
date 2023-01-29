//
//  HomeRouter.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/25/23.
//

import Foundation

protocol HomeRouterInput {
    func showDetailsScreen(conversionModel: PairConversionModel)
}

class HomeRouter: BaseModuleRouter, HomeRouterInput  {
    
    typealias TransitionHandler = HomeViewController
    var transitionHandler: HomeViewController?
    
    required init(handler: HomeViewController) {
        self.transitionHandler = handler
    }
    
    func showDetailsScreen(conversionModel: PairConversionModel) {
        let detailsVc = DetailsAssembly.viewModule(conversionModel: conversionModel)
        self.transitionHandler?.pushModuleInterface(controller: detailsVc, animated: true)
    }
    
}


