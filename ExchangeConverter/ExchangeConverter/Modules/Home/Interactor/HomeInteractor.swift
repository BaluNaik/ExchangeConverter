//
//  HomeInteractor.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/25/23.
//

import Foundation

struct CurrencyViewModel {
    var base: String
    var timestamp: Double
    var rates: [String: Double] = [:]
}


protocol HomeInteractorInput: BaseModuleInteractorInput {
    var currentBase: String? { get }
    
    func getCurrencyList(for base: String?, completion:@escaping (_ errorMsg: String?) -> ())
    func calculateAmount(amount: Int, currency: String) -> (from: String, to: String)
    func getCurrencyCodes(for type: CurrentTextField) -> [String]
}

protocol HomeInteractorOutput: BaseModuleInteractorOutput { }


protocol HomeInteractorInterface: BaseModuleInteractor {
    
    var currency: CurrencyViewModel? { set get }
}

class HomeInteractor: HomeInteractorInterface {
    
    typealias Presenter = HomeInteractorOutput
    weak var presenter: Presenter?
    var currency: CurrencyViewModel?
    private var connector: HomeConnectorInterface?
    
    required init(presenter: Presenter) {
        self.presenter = presenter
        connector = HomeConnector()
    }
    
}

extension HomeInteractor: HomeInteractorInput {
    var currentBase: String? {
        return currency?.base
    }
    
    func getCurrencyList(for base: String?, completion:@escaping (_ errorMsg: String?) -> ()) {
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
    
    func calculateAmount(amount: Int, currency: String) -> (from: String, to: String) {
        let rate = self.currency?.rates[currency] ?? 0.0
        
        
        return ("\(amount) \(self.currentBase ?? "")", "\(rate * Double(amount)) \(currency)")
    }
}


// MARK: - private

private extension HomeInteractor {
    
    func transform(_ response: CurrencyAPIModel) {
        if let baseCode = response.base,
           let timeStamp = response.timestamp,
           let rates = response.rates {
            self.currency = CurrencyViewModel(base: baseCode, timestamp: timeStamp, rates: rates)
        }
    }
    
}
