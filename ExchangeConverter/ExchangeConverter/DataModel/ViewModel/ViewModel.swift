//
//  ViewModel.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/28/23.
//

import Foundation


struct ConversionViewModel {
    var key: String
    var rate: Double
}

struct CurrencyViewModel {
    var base: String
    var timestamp: Double
    var rates: [String: Double] = [:]
    
    func isExpired() -> Bool {
        let currentTimeStamp = Double(Date().timeIntervalSince1970)
        return currentTimeStamp > self.timestamp
    }
}
