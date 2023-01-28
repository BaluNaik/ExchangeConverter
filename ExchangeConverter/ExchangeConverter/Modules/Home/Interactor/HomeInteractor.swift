//
//  HomeInteractor.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/25/23.
//

import Foundation

protocol HomeInteractorInput: BaseModuleInteractorInput {
    var currentBase: String? { get }
    var currency: CurrencyViewModel? { set get }
    
    func getCurrencyCodes(for type: CurrentTextField) -> [String]
    
    func eventLoadData(for base: String?,
                         completion:@escaping (_ errorMsg: String?) -> ())
    
    func getTransferDetails(for currency: String, completion:@escaping (RateViewModel, RateViewModel?) -> ())
}

protocol HomeInteractorOutput: BaseModuleInteractorOutput { }


// MARK: - HomeInteractor

class HomeInteractor: BaseModuleInteractor {
    
    typealias Presenter = HomeInteractorOutput
    weak var presenter: Presenter?
    var currency: CurrencyViewModel?
    private var connector: HomeConnectorInterface?
    
    required init(presenter: Presenter) {
        self.presenter = presenter
        connector = HomeConnector()
    }
    
}


// MARK: - HomeInteractorInput

extension HomeInteractor: HomeInteractorInput {
    
    var currentBase: String? {
        return currency?.base
    }
    
    func eventLoadData(for base: String?, completion: @escaping (String?) -> ()) {
        /*
          * Check local storage availability
          * If local storage not expired
          * Load from local storage
          * else make network request
         */
        self.connector?.getCurrencyList(for: base ?? "USD", completion: {[weak self] result in
            switch result {
            case .success(let success):
                self?.transform(success)
                completion(nil)
            case .failure(let failure):
                completion(failure.localizedDescription)
            }
        })
    }
    
    func getCurrencyCodes(for type: CurrentTextField) -> [String] {
        if type == .source,
           let allKeys = currency?.rates.keys {
            var keys = [String]()
            keys.append(contentsOf: allKeys)
            return keys.sorted()
        } else if type == .destination,
                  let allKeys = currency?.rates.keys {
            var keys = [String]()
            keys.append(contentsOf: allKeys)
            if let index = keys.firstIndex(of: self.currency?.base ?? "") {
                keys.remove(at: index)
            }
            return keys.sorted()
        }
        return []
    }
    
    func getTransferDetails(for currency: String, completion:@escaping (RateViewModel, RateViewModel?) -> ()) {
        let base = RateViewModel(key: currentBase ?? "USD", rate: 1.0)
        if let transferRate = self.currency?.rates[currency], transferRate > 0.0 {
            let destination = RateViewModel(key: currency, rate: transferRate)
            completion(base, destination)
            return
        }
        completion(base, nil)
    }
}


// MARK: - Private

private extension HomeInteractor {
    
    func transform(_ response: CurrencyAPIModel) {
        if let baseCode = response.base,
           let timeStamp = response.timestamp,
           let rates = response.rates {
            self.currency = CurrencyViewModel(base: baseCode, timestamp: timeStamp, rates: rates)
        }
    }
}
