//
//  HomeInteractor.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/25/23.
//

import Foundation

protocol HomeInteractorInput: BaseModuleInteractorInput {
    
}

protocol HomeInteractorOutput: BaseModuleInteractorOutput {
    
}


protocol HomeInteractorInterface: BaseModuleInteractor {
    
//    var offset: String? { set get }
//    var feedService: NewsFeedService! { set get }
//    var postService: PostService! { set get }
//
//    init(feedService: NewsFeedService, postService: PostService)
}

class HomeInteractor: HomeInteractorInterface {
   
    typealias Presenter = HomeInteractorOutput
    weak var presenter: Presenter?
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
}

extension HomeInteractor: HomeInteractorInput {
    
}
