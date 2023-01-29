//
//  CoreDataManagerTest.swift
//  ExchangeConverterTests
//
//  Created by Balu Naik on 1/29/23.
//

import XCTest
@testable import ExchangeConverter

final class CoreDataManagerTest: ExchangeConverterTests {
    var sut: CoredataManager!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    func testCoreData() throws {
//        sut = CoredataManager.shared
//        let pairmodel = PairConversionModel(base: "USD", target: "AED",timestamp: 1675036801,conversionRate: 3.6725)
//        sut.saveData(response: pairmodel)
//        
//        let some =  sut.getConversionDetails(for: pairmodel)
//        XCTAssertEqual(some!.baseCode, "USD")
//        XCTAssertEqual(some!.targetCode, "AED")
//        XCTAssertEqual(some!.timeStamp, 1675036801)
//        XCTAssertEqual(some!.conversionRate, 3.6725)
    }
    
}
