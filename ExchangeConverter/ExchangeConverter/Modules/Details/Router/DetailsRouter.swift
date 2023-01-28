//
//  DetailsRouter.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/28/23.
//

import Foundation
import SwiftUI

protocol DetailsRouterInput {
    func showSucessScreen(total: String, rate: String)
}

class DetailsRouter: BaseModuleRouter, DetailsRouterInput  {
    
    typealias TransitionHandler = DetailsViewController
    var transitionHandler: DetailsViewController?
    
    required init(handler: DetailsViewController) {
        self.transitionHandler = handler
    }
    
    func showSucessScreen(total: String, rate: String){
        if let naviBar = self.transitionHandler?.navigationController {
            let swiftUIViewController = UIHostingController(rootView: SucessUIView(navigationController: naviBar, rate: rate, totalAmount: total))
            self.transitionHandler?.pushModuleInterface(controller: swiftUIViewController, animated: true)
        }
       
    }
    
}
