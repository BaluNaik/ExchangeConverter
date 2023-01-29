//
//  CurrencyAPIModel.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/26/23.
//

import Foundation

struct CurrencyAPIModel: Codable {
    
    var base: String?
    var timestamp: Double?
    var rates: [String: Double]?
    
    enum CodingKeys: String, CodingKey {
        case base = "base_code"
        case timestamp = "time_next_update_unix"
        case rates = "conversion_rates"
    }
    
    init(base: String, timestamp: Double, rates: [String: Double]? = nil) {
        self.base = base
        self.timestamp = timestamp
        self.rates = rates
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let baseCode = try values.decodeIfPresent(String.self, forKey: .base) {
            base = baseCode
        }
        if let serverTime = try values.decodeIfPresent(Double.self, forKey: .timestamp) {
            self.timestamp = serverTime
        }
        if let rates = try values.decodeIfPresent([String: Double].self, forKey: .rates) {
            self.rates = rates
        }
    }
}
