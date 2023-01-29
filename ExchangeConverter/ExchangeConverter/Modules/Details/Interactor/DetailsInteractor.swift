//
//  DetailsInteractor.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/28/23.
//

import Foundation

protocol DetailsInteractorInput: BaseModuleInteractorInput { }

protocol DetailsInteractorOutput: BaseModuleInteractorOutput { }


class DetailsInteractor: BaseModuleInteractor {
    
    typealias Presenter = DetailsInteractorOutput
    weak var presenter: Presenter?
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
}


// MARK: - DetailsInteractorInput

extension DetailsInteractor: DetailsInteractorInput { }
