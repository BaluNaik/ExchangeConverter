//
//  ViewModel.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/28/23.
//

import Foundation


struct RateViewModel {
    var key: String
    var rate: Double
}

struct CurrencyViewModel {
    var base: String
    var timestamp: Double
    var rates: [String: Double] = [:]
}
