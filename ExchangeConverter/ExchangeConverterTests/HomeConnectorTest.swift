//
//  HomeConnectorTest.swift
//  ExchangeConverterTests
//
//  Created by Balu Naik on 1/29/23.
//

import XCTest
@testable import ExchangeConverter

final class HomeConnectorTest: ExchangeConverterTests {
    var sut: HomeConnector!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = HomeConnector()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testFetchCurrencyRateSuccess() {
        let promise = expectation(description: "Completion handler invoked")
        sut.getCurrencyList(for: "USD") { result in
            switch result {
            case .success(let model):
                XCTAssertNotNil(model)
            case .failure(let error):
                XCTAssertNil(error)
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }
    
    func testFetchLocalDataSuccess() {
//        let promise = expectation(description: "Completion handler invoked")
//        var pairmodel = PairConversionModel(base: "USD", target: "AED",conversionRate:3.6725)
//        pairmodel.amount = 1000
//        sut.getLocalConversion(for: pairmodel) { result in
//            switch result {
//            case .success(let model):
//                XCTAssertNotNil(model)
//            case .failure(let error):
//                XCTAssertNil(error)
//            }
//            promise.fulfill()
//        }
//        wait(for: [promise], timeout: 10)
    }

}
