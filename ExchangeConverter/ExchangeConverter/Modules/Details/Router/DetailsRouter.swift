//
//  DetailsRouter.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/28/23.
//

import Foundation

protocol DetailsRouterInput {
    func showSucessScreen()
}

class DetailsRouter: BaseModuleRouter, DetailsRouterInput  {
    
    typealias TransitionHandler = DetailsViewController
    var transitionHandler: DetailsViewController?
    
    required init(handler: DetailsViewController) {
        self.transitionHandler = handler
    }
    
    func showSucessScreen() {}
    
}
