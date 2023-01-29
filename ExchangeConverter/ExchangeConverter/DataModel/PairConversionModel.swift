//
//  PairConversionModel.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/29/23.
//

import Foundation

struct PairConversionModel: Codable {
    
    var base: String?
    var target: String?
    var timestamp: Double?
    var conversionRate: Double?
    var totalAmount: Double?
    var amount: Int?
    
    enum CodingKeys: String, CodingKey {
        case base = "base_code"
        case target = "target_code"
        case timestamp = "time_next_update_unix"
        case conversionRate = "conversion_rate"
        case totalAmount = "conversion_result"
    }
    
    init(base: String,
         target: String,
         timestamp: Double? = 0.0,
         conversionRate: Double? = 0.0,
         totalAmount: Double? = 0.0) {
        self.base = base
        self.target = target
        self.timestamp = timestamp
        self.conversionRate = conversionRate
        self.totalAmount = totalAmount
    }
    
    init(from data: PairConversion) {
        self.base = data.baseCode
        self.target = data.targetCode
        self.conversionRate = data.conversionRate
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let baseCode = try values.decodeIfPresent(String.self, forKey: .base) {
            base = baseCode
        }
        if let targetCode = try values.decodeIfPresent(String.self, forKey: .target) {
            target = targetCode
        }
        if let serverTime = try values.decodeIfPresent(Double.self, forKey: .timestamp) {
            /*
             * Keep next update time frame for 5hr
             * If server next update time < 5hr? Keep server time
             * If server next update time > 5hr? make next update time with 5hr frame
             */
            let nextTimeStamp = Double(Int(Date().timeIntervalSince1970) + 18000)
            self.timestamp = serverTime > nextTimeStamp ? nextTimeStamp : serverTime
        }
        if let rate = try values.decodeIfPresent(Double.self, forKey: .conversionRate) {
            conversionRate = rate
        }
        if let amount = try values.decodeIfPresent(Double.self, forKey: .totalAmount) {
            totalAmount = amount
        }
    }
}
