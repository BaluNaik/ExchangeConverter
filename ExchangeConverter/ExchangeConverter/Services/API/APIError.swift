//
//  APIError.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/26/23.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    case badURL
    case badResponse(statusCode: Int)
    case url(URLError?)
    case parsing(DecodingError?)
    case unknown
    
    var description: String {
        switch self {
        case .unknown: return "Unknown Error"
        case .badURL: return "Invalid URL"
        case .url(let error):
            return error?.localizedDescription ?? "Url session error"
        case .parsing(let error):
            return "Parsing error \(error?.localizedDescription ?? "")"
        case .badResponse(statusCode: let statusCode):
            return "Bad response with status code \(statusCode)"
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .badURL, .parsing, .unknown:
            return "Sorry, something went wrong."
        case .badResponse(_):
            return "Sorry, the connection to our server failed."
        case .url(let error):
            return error?.localizedDescription ?? "Something went wrong."
        }
    }
}
