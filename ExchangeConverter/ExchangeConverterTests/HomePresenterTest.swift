//
//  HomePresenterTest.swift
//  ExchangeConverterTests
//
//  Created by Balu Naik on 1/29/23.
//

import XCTest
@testable import ExchangeConverter


// MARK: - HomeInteractorMockForSuccess

class HomeInteractorMockForSuccess: HomeInteractorInput {
    var isExpried: Bool? = false
    var currency: CurrencyViewModel?
    var currentBase: String? = "USD"
    
    func getCurrencyCodes(for type: CurrentTextField) -> [String] {
        if type == .source {
            return ["USD", "AED","AFN","ALL","AMD","ANG"]
        } else {
            return ["AED","AFN","ALL","AMD","ANG"]
        }
    }
    
    func eventLoadData(for base: String?, completion: @escaping (String?) -> ()) {
        currency = CurrencyViewModel(base: "USD", timestamp: 1675009279, rates: ["USD": 1,
                                                                                 "AED": 3.6725,
                                                                                 "AFN": 88.9104,
                                                                                 "ALL": 107.3989,
                                                                                 "AMD": 396.3738,
                                                                                 "ANG": 1.79])
        DispatchQueue.main.async {
            completion(nil)
        }
    }
    
    func getTransferDetails(for currency: String, amount: Int, completion:@escaping (PairConversionModel?, String?) -> ()) {
        var data = PairConversionModel(base: currentBase ?? "USD", target: "AED",conversionRate: 3.6725)
        data.amount = amount
        data.totalAmount = (data.conversionRate! * Double(amount))
        DispatchQueue.main.async {
            completion(data, nil)
        }
    }
}


// MARK: - HomeInteractorMockForFailure

class HomeInteractorMockForFailure: HomeInteractorInput {
    var isExpried: Bool? = false
    var currency: CurrencyViewModel?
    var currentBase: String? = "USD"
    
    func getCurrencyCodes(for type: CurrentTextField) -> [String] {
        return []
    }
    
    func eventLoadData(for base: String?, completion: @escaping (String?) -> ()) {
        DispatchQueue.main.async {
            completion(APIError.unknown.localizedDescription)
        }
    }
    
    func getTransferDetails(for currency: String, amount: Int, completion:@escaping (PairConversionModel?, String?) -> ()) {
        DispatchQueue.main.async {
            completion(nil, APIError.storageError.localizedDescription)
        }
    }
}



final class HomePresenterTest: ExchangeConverterTests {
    
    var sut: HomePresenter!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testLoadDataOnSucess() throws {
        let promise = expectation(description: "Get Currency View Model")
        sut = HomePresenter()
        sut.interactor = HomeInteractorMockForSuccess()
        sut.eventLoadData(for: "USD") { errorMsg in
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
        XCTAssertNotNil(sut.interactor?.currency)
        XCTAssertEqual(sut.interactor?.currency?.rates.count, 6)
    }
    
    func testLoadDataOnFilure() throws {
        let promise = expectation(description: "Currency View Model should empty")
        sut = HomePresenter()
        sut.interactor = HomeInteractorMockForFailure()
        sut.eventLoadData(for: "USD") { errorMsg in
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
        XCTAssertNil(sut.interactor?.currency)
        XCTAssertNil(sut.interactor?.currency?.rates)
    }
    
    func testCurrencyCodesOnSuccess() throws {
        sut = HomePresenter()
        sut.interactor = HomeInteractorMockForSuccess()
        let codes = sut.getCurrencyCodes(for: .source)
        XCTAssertEqual(codes.count, 6)
        XCTAssert(codes == ["USD", "AED","AFN","ALL","AMD","ANG"])
        
        let codes2 = sut.getCurrencyCodes(for: .destination)
        XCTAssertEqual(codes2.count, 5)
        XCTAssert(codes2 == ["AED","AFN","ALL","AMD","ANG"])
    }
    
    func testCurrencyCodesOnFailure() throws {
        sut = HomePresenter()
        sut.interactor = HomeInteractorMockForFailure()
        let codes = sut.getCurrencyCodes(for: .source)
        XCTAssertTrue(codes.isEmpty)
        
        let codes2 = sut.getCurrencyCodes(for: .destination)
        XCTAssertTrue(codes2.isEmpty)
    }
    
    func testTransferDetailsOnSuccess() throws {
        var model: PairConversionModel?
        let promise = expectation(description: "Get Transfer Details USD -> AED")
        sut = HomePresenter()
        sut.interactor = HomeInteractorMockForSuccess()
        sut.interactor?.getTransferDetails(for: "AED", amount: 1000, completion: { data, errorMsg in
            model = data
            promise.fulfill()
        })
        wait(for: [promise], timeout: 10)
        XCTAssertEqual(model?.base, "USD")
        XCTAssertEqual(model?.target, "AED")
        XCTAssertEqual(model?.conversionRate, 3.6725)
        XCTAssertEqual(model?.amount, 1000)
        XCTAssertEqual(model?.totalAmount, 3672.50)
    }
    
    func testTransferDetailsOnFilure() throws {
        var model: PairConversionModel?
        var msg: String?
        
        let promise = expectation(description: "Get Filure Transfer Details USD -> AED")
        sut = HomePresenter()
        sut.interactor = HomeInteractorMockForFailure()
        sut.interactor?.getTransferDetails(for: "AED", amount: 1000, completion: { data, errorMsg in
            model = data
            msg = errorMsg
            promise.fulfill()
        })
        wait(for: [promise], timeout: 10)
        XCTAssertNil(model)
        XCTAssertEqual(msg, APIError.storageError.localizedDescription)
    }

}
