//
//  HomeRouter.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/25/23.
//

import Foundation

protocol HomeRouterInput {
    
}

class HomeRouter: BaseModuleRouter, HomeRouterInput  {
    
    typealias TransitionHandler = HomeViewController
    var transitionHandler: HomeViewController?
    
    required init(handler: HomeViewController) {
        self.transitionHandler = handler
    }
}


