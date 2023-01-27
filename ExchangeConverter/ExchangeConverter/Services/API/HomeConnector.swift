//
//  HomeConnector.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/26/23.
//

import Foundation

protocol HomeConnectorInterface: AnyObject {
    
    func getCurrencyList(for currency: String,
                         completion: @escaping (Result<CurrencyAPIModel, APIError>) -> ())

}

class HomeConnector: HomeConnectorInterface {
    init() {}
    
    private let url = "https://v6.exchangerate-api.com/v6/"
    private let appId = "b5362afa80af8bfe92f310ef"
    
    func getCurrencyList(for currency: String, completion: @escaping (Result<CurrencyAPIModel, APIError>) -> ()) {
        if let localCurrency = self.getStorageList(for: currency) {
            completion(.success(localCurrency))
            return
        }
        let urlString = "\(url)\(appId)/latest/\(currency)"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: URLRequest(url: url)) {[weak self] data, response, error in
                if let error = error as? URLError {
                    let urlError = APIError.url(error)
                    completion(.failure(urlError))
                    return
                } else if let response = response as? HTTPURLResponse,
                          !(200...299).contains(response.statusCode) {
                    completion(.failure(APIError.badResponse(statusCode: response.statusCode)))
                } else if let data = data {
                    do {
                        let response = try JSONDecoder().decode(CurrencyAPIModel.self, from: data)
                        self?.saveData(response: response)
                        completion(.success(response))
                    } catch {
                        let error =  APIError.parsing(error as? DecodingError)
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
}


// MARK: - Local Storage

private extension HomeConnector {
    
    func getStorageList(for currency:String) -> CurrencyAPIModel? {
        if let item = CoredataManager.shared.fetchObjects(attributes: ["base" : currency], inputType: BaseCoreDataModel.self)?.first {
            let expireDate = Date(timeIntervalSince1970: item.timeStamp)
            if expireDate > Date(),
               let baseCode = item.base {
                var model = CurrencyAPIModel(base: baseCode, timestamp: item.timeStamp)
                if let rates = item.rates as? Set<RateCoreDataModel> {
                    model.rates =  Dictionary(uniqueKeysWithValues: rates.map{ ($0.currency ?? "", $0.rate ) })
                }
                return model
            }
        }
        return nil
    }
    
    func saveData(response: CurrencyAPIModel) {
        if let baseCode = response.base,
           let currency = CoredataManager.shared.fetchObjects(attributes: ["base": baseCode], inputType: BaseCoreDataModel.self)?.first {
            currency.base = response.base
            if let timestamp = response.timestamp {
                currency.timeStamp = timestamp
            }
            currency.rates = nil
            for item in response.rates ?? [:] {
                if let rateCoredataModel = CoredataManager.shared.fetchObjects(attributes: ["currency" : item.key], inputType: RateCoreDataModel.self)?.first  {
                    rateCoredataModel.currency = item.key
                    rateCoredataModel.rate = item.value
                    currency.addToRates(rateCoredataModel)
                } else {
                    let rateCoredataModel = RateCoreDataModel(context: CoredataManager.shared.context)
                    rateCoredataModel.currency = item.key
                    rateCoredataModel.rate = item.value
                    currency.addToRates(rateCoredataModel)
                }
            }
        } else {
            let currency = BaseCoreDataModel(context: CoredataManager.shared.context)
            currency.base = response.base
            if let timestamp = response.timestamp {
                currency.timeStamp = timestamp
            }
            for item in response.rates ?? [:] {
                let rateCoredataModel = RateCoreDataModel(context: CoredataManager.shared.context)
                rateCoredataModel.currency = item.key
                rateCoredataModel.rate = item.value
                currency.addToRates(rateCoredataModel)
            }
        }
        CoredataManager.shared.saveContext()
    }
}
