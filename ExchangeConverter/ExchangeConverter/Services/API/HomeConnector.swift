//
//  HomeConnector.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/26/23.
//

import Foundation

protocol HomeConnectorInterface: AnyObject {
    
    func getCurrencyList(for currency: String, completion: @escaping (Result<CurrencyAPIModel, Error>) -> ())

}

class HomeConnector: HomeConnectorInterface {
    init() {}
    
    private let url = "https://v6.exchangerate-api.com/v6/"
    private let appId = "b5362afa80af8bfe92f310ef"
    
    func getCurrencyList(for currency: String, completion: @escaping (Result<CurrencyAPIModel, Error>) -> ()) {
        let urlString = "\(url)\(appId)/latest/\(currency)"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
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
