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
    
    func getPairConversion(for pair: PairConversionModel,
                         completion: @escaping (Result<PairConversionModel, APIError>) -> ())
    
    
    func getLocalConversion(for pair: PairConversionModel, completion: @escaping (Result<PairConversionModel, APIError>) -> ())

}

class HomeConnector: HomeConnectorInterface {
    
    private let url = "https://v6.exchangerate-api.com/v6/"
    private let appId = "b5362afa80af8bfe92f310ef"
    
    init() {}
    
    func getLocalConversion(for pair: PairConversionModel, completion: @escaping (Result<PairConversionModel, APIError>) -> ()) {
        if let localData = self.getLocalConversion(for: pair) {
            completion(.success(localData))
            return
        } else {
            completion(.failure(APIError.storageError))
        }
    }
    
    func getCurrencyList(for currency: String, completion: @escaping (Result<CurrencyAPIModel, APIError>) -> ()) {
        let urlString = "\(url)\(appId)/latest/\(currency)"
        if let url = URL(string: urlString) {
            self.DataTask(url: url, inputType: CurrencyAPIModel.self) { result in
                switch result {
                case .success(let model):
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getPairConversion(for pair: PairConversionModel,
                           completion: @escaping (Result<PairConversionModel, APIError>) -> ()) {
        let fromCode = pair.base!, toCode = pair.target!
        let amount = pair.amount!
        let urlString = "\(url)\(appId)/pair/\(fromCode)/\(toCode)/\(amount)"
        if let url = URL(string: urlString) {
            self.DataTask(url: url, inputType: PairConversionModel.self) { result in
                switch result {
                case .success(let model):
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}


// MARK: - Local Storage

private extension HomeConnector {
    
    func getLocalConversion(for pair: PairConversionModel) -> PairConversionModel? {
        if let item = CoredataManager.shared.getConversionDetails(for: pair) {
            let expireDate = Date(timeIntervalSince1970: item.timeStamp)
            if expireDate > Date() {
                return PairConversionModel(from: item)
            }
        }
        return nil
    }
    
    func saveData(response: PairConversionModel) {
        CoredataManager.shared.saveData(response: response)
    }
    
    func convertToArray<T>(_ element: T) -> [T] {
        return [element]
    }
    
    func DataTask<T: Decodable>(url: URL, inputType: T.Type, completion: @escaping (Result<T, APIError>) -> ()) {
        URLSession.shared.dataTask(with: URLRequest(url: url)) {(data, response, error) in
            if let error = error as? URLError {
                let urlError = APIError.url(error)
                completion(.failure(urlError))
                return
            } else if let response = response as? HTTPURLResponse,
                      !(200...299).contains(response.statusCode) {
                completion(.failure(APIError.badResponse(statusCode: response.statusCode)))
            } else if let data = data,
                      let response = CodableParser.parse(data, type: T.self) {
                completion(.success(response))
            } else {
                let error =  APIError.parsing(error as? DecodingError)
                completion(.failure(error))
            }
        }.resume()
    }
    
}


// MARK: - Generics Parser

class CodableParser {
    class func parse<T: Decodable>(_ data: Data, type: T.Type) -> T? {
        var decodedData: T?
        decodedData = try? JSONDecoder().decode(T.self, from: data)

        return decodedData
    }
}
