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
    var isExpried: Bool? { get }
    
    func getCurrencyCodes(for type: CurrentTextField) -> [String]
    func eventLoadData(for base: String?,
                         completion:@escaping (_ errorMsg: String?) -> ())
    
    func getTransferDetails(for currency: String, amount: Int, completion:@escaping (PairConversionModel?, String?) -> ())
}

protocol HomeInteractorOutput: BaseModuleInteractorOutput { }


// MARK: - HomeInteractor

class HomeInteractor: BaseModuleInteractor {
    
    typealias Presenter = HomeInteractorOutput
    weak var presenter: Presenter?
    var currency: CurrencyViewModel?
    var connector: HomeConnectorInterface?
    
    init(){}
    
    required init(presenter: Presenter) {
        self.presenter = presenter
        connector = HomeConnector()
    }
    
    func transform(_ response: CurrencyAPIModel) {
        if let baseCode = response.base,
           let timeStamp = response.timestamp,
           let rates = response.rates {
            self.currency = CurrencyViewModel(base: baseCode, timestamp: timeStamp, rates: rates)
        }
    }
    
}


// MARK: - HomeInteractorInput

extension HomeInteractor: HomeInteractorInput {
    
    var currentBase: String? {
        return currency?.base
    }
    
    var isExpried: Bool? { return currency?.isExpired() }
    
    func eventLoadData(for base: String?, completion: @escaping (String?) -> ()) {
        self.connector?.getCurrencyList(for: base ?? "USD", completion: { [weak self] result in
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
    
    func getTransferDetails(for currency: String, amount: Int, completion:@escaping (PairConversionModel?, String?) -> ()) {
        self.connector?.getLocalConversion(for: PairConversionModel(base: currentBase ?? "USD", target: currency), completion: {[weak self] result in
            switch result {
            case .success(let data):
                var finalData = data
                finalData.amount = amount
                finalData.totalAmount = (data.conversionRate! * Double(amount)).roundToDecimal(2)
                completion(finalData, nil)
            case .failure(_):
                var pair = PairConversionModel(base: self?.currentBase ?? "USD", target: currency)
                pair.amount = amount
                self?.connector?.getPairConversion(for:pair, completion: { result in
                    switch result {
                    case .success(let model):
                        var finalData = model
                        finalData.amount = amount
                        completion(finalData, nil)
                    case .failure(let error):
                        completion(nil, error.localizedDescription)
                    }
                })
            }
        })
    }
}
