//
//  DataManagerInputProtocol.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/26/23.
//

import Foundation

protocol APIManagerInputProtocol: AnyObject {
    
   func fetchCurrencyFromServerWithData(_ baseCurrencyCode: String,
                                        completion: ((AnyObject) -> Void),
                                        failed:((AnyObject) -> Void))
}
