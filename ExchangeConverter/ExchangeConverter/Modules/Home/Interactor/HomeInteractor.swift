//
//  HomeInteractor.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/25/23.
//

import Foundation

struct CurrencyModel {
    var base: String
    var timestamp: Double
    var rates: [String: Double] = [:]
}


protocol HomeInteractorInput: BaseModuleInteractorInput {
    func getCurrencyList(for base: String?, completion:@escaping (_ status: Bool) -> ())
    func calculateAmount(amount: Int, currency: String) -> (from: String, to: String)
    func getCurrencyCodes(for type: CurrentTextField) -> [String]
}

protocol HomeInteractorOutput: BaseModuleInteractorOutput {
    
}


protocol HomeInteractorInterface: BaseModuleInteractor {
    
    var currency: CurrencyModel? { set get }
//    var feedService: NewsFeedService! { set get }
//    var postService: PostService! { set get }
//
//    init(feedService: NewsFeedService, postService: PostService)
    //func getCurrencyRate(for currency: String, completion:@escaping (Result<CurrencyModel,Error>) -> ())
}

class HomeInteractor: HomeInteractorInterface {
    
    typealias Presenter = HomeInteractorOutput
    weak var presenter: Presenter?
    var currency: CurrencyModel?
    private var connector: HomeConnectorInterface?
    
    required init(presenter: Presenter) {
        self.presenter = presenter
        connector = HomeConnector()
    }
    
}

extension HomeInteractor: HomeInteractorInput {
    
    func getCurrencyList(for base: String?, completion:@escaping (_ status: Bool) -> ()) {
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
                completion(true)
            case .failure(let failure):
                completion(false)
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
        
        return ("100.00 USD", "1500 AED")
    }
}


// MARK: - private

private extension HomeInteractor {
    
    func transform(_ response: CurrencyAPIModel) {
        if let baseCode = response.base,
           let timeStamp = response.timestamp,
           let rates = response.rates {
            self.currency = CurrencyModel(base: baseCode, timestamp: timeStamp, rates: rates)
        }
    }
    
}
