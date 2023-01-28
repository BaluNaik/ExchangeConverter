//
//  Double+Externsion.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/28/23.
//

import Foundation

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
