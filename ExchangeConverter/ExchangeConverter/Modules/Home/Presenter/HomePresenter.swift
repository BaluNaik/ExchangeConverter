//
//  HomePresenter.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/25/23.
//

import Foundation

protocol HomePresenterInput: BaseModulePresenterInput {
    
}

protocol HomePresenterOutput: BaseModulePresenterOutput {
    
}


protocol HomePresenterInterface: BaseModulePresenter {
    
//    var offset: String? { set get }
//    var feedService: NewsFeedService! { set get }
//    var postService: PostService! { set get }
//
}

class HomePresenter: HomePresenterInterface {
    
    typealias UserInterface = BaseModulePresenterOutput
    weak var userInterface: UserInterface?
    
    typealias Interactor = HomeInteractorInput
    var interactor: Interactor?
    
    typealias Router = HomeRouterInput
    var router: Router?
    
    required init(userInterface: UserInterface) {
        self.userInterface = userInterface
    }
    
}


extension HomePresenter: HomeInteractorOutput {
    
}

extension HomePresenter: HomePresenterInput {
    
}
