//
//  HomeInteractorTest.swift
//  ExchangeConverterTests
//
//  Created by Balu Naik on 1/29/23.
//

import XCTest
@testable import ExchangeConverter


// MARK: - HomeConnectorMockForSuccess

class HomeConnectorMockForSuccess: HomeConnectorInterface {
    
    func getPairConversion(for pair: PairConversionModel, completion: @escaping (Result<PairConversionModel, APIError>) -> ()) {
        var data = pair
        data.totalAmount = (data.conversionRate! * Double(data.amount!))
        DispatchQueue.main.async {
            completion(.success(data))
        }
    }
    
    func getLocalConversion(for pair: PairConversionModel, completion: @escaping (Result<PairConversionModel, APIError>) -> ()) {
        var data = pair
        data.totalAmount = (data.conversionRate! * Double(data.amount!))
        DispatchQueue.main.async {
            completion(.success(data))
        }
    }
    
    func getCurrencyList(for currency: String, completion: @escaping (Result<CurrencyAPIModel, APIError>) -> ()) {
        let model = CurrencyAPIModel(base: "USD", timestamp: 1674976890, rates: ["USD": 1,
                                                                                 "AED": 3.6725,
                                                                                 "AFN": 88.9104,
                                                                                 "ALL": 107.3989,
                                                                                 "AMD": 396.3738,
                                                                                 "ANG": 1.79])
        DispatchQueue.main.async {
            completion(.success(model))
        }
    }
}


// MARK: - HomeConnectorForFailure

class HomeConnectorForFailure: HomeConnectorInterface {
    
    func getPairConversion(for pair: PairConversionModel, completion: @escaping (Result<PairConversionModel, APIError>) -> ()) {
        var data = pair
        data.totalAmount = (data.conversionRate! * Double(data.amount!))
        DispatchQueue.main.async {
            completion(.failure(APIError.badURL))
        }
    }
    
    func getLocalConversion(for pair: PairConversionModel, completion: @escaping (Result<PairConversionModel, APIError>) -> ()) {
        var data = pair
        data.totalAmount = (data.conversionRate! * Double(data.amount!))
        DispatchQueue.main.async {
            completion(.failure(APIError.storageError))
        }
    }
    
    
    func getCurrencyList(for currency: String, completion: @escaping (Result<CurrencyAPIModel, APIError>) -> ()) {
        DispatchQueue.main.async {
            completion(.failure(APIError.badURL))
        }
    }
}

final class HomeInteractorTest: ExchangeConverterTests {
    
    var sut: HomeInteractor!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testGetNetworkListOnSuccess() throws {
        let promise = expectation(description: "Get Currency list from network")
        sut = HomeInteractor()
        sut.connector = HomeConnectorMockForSuccess()
        sut.connector?.getCurrencyList(for: "USD", completion: { result in
            switch result {
            case .success(let model):
                self.sut.transform(model)
            case .failure(_):
                
                break
            }
            promise.fulfill()
        })
        wait(for: [promise], timeout: 10)
        XCTAssertNotNil(sut.currency)
        XCTAssertEqual(sut.currency?.rates.count, 6)
        XCTAssertEqual(sut.currency?.base, "USD")
    }
    
    func testGetNetworkListOnFailure() throws {
        var errorCode: APIError?
        let promise = expectation(description: "On failure to get network list")
        sut = HomeInteractor()
        sut.connector = HomeConnectorForFailure()
        sut.connector?.getCurrencyList(for: "USD", completion: { result in
            switch result {
            case .success(let model):
                self.sut.transform(model)
            case .failure(let error):
                errorCode = error
                break
            }
            promise.fulfill()
        })
        wait(for: [promise], timeout: 10)
        XCTAssertNil(sut.currency)
        XCTAssertEqual(errorCode?.localizedDescription, APIError.badURL.localizedDescription)
    }
    
    func testGetLocalConversionOnSuccess() throws {
        let promise = expectation(description: "Get Currency list from network")
        sut = HomeInteractor()
        sut.connector = HomeConnectorMockForSuccess()
        var pairmodel = PairConversionModel(base: "USD", target: "AED",conversionRate:3.6725)
        pairmodel.amount = 1000
        sut.connector?.getLocalConversion(for: pairmodel, completion: { result in
            switch result {
            case .success(let model):
                pairmodel = model
            case .failure(_):
                break
            }
            promise.fulfill()
        })
        wait(for: [promise], timeout: 10)
        XCTAssertEqual(pairmodel.base, "USD")
        XCTAssertEqual(pairmodel.target, "AED")
        XCTAssertEqual(pairmodel.conversionRate, 3.6725)
        XCTAssertEqual(pairmodel.amount, 1000)
        XCTAssertEqual(pairmodel.totalAmount, 3672.50)
    }
    
    func testGetLocalConversionOnFailure() throws {
        var errorCode: APIError?
        let promise = expectation(description: "On failure to get network list")
        sut = HomeInteractor()
        sut.connector = HomeConnectorForFailure()
        var pairmodel = PairConversionModel(base: "USD", target: "AED",conversionRate:3.6725)
        pairmodel.amount = 1000
        sut.connector?.getLocalConversion(for: pairmodel, completion: { result in
            switch result {
            case .success(let model):
                pairmodel = model
            case .failure(let error):
                errorCode = error
                break
            }
            promise.fulfill()
        })
        wait(for: [promise], timeout: 10)
        XCTAssertEqual(pairmodel.base, "USD")
        XCTAssertEqual(pairmodel.target, "AED")
        XCTAssertEqual(pairmodel.conversionRate, 3.6725)
        XCTAssertEqual(pairmodel.amount, 1000)
        XCTAssertEqual(pairmodel.totalAmount, 0.0)
        XCTAssertEqual(errorCode?.localizedDescription, APIError.badURL.localizedDescription)
    }
    
    func testGetConversionOnSuccess() throws {
        let promise = expectation(description: "Get Currency list from network")
        sut = HomeInteractor()
        sut.connector = HomeConnectorMockForSuccess()
        var pairmodel = PairConversionModel(base: "USD", target: "AED",conversionRate:3.6725)
        pairmodel.amount = 1000
        sut.connector?.getPairConversion(for: pairmodel, completion: { result in
            switch result {
            case .success(let model):
                pairmodel = model
            case .failure(_):
                break
            }
            promise.fulfill()
        })
        wait(for: [promise], timeout: 10)
        XCTAssertEqual(pairmodel.base, "USD")
        XCTAssertEqual(pairmodel.target, "AED")
        XCTAssertEqual(pairmodel.conversionRate, 3.6725)
        XCTAssertEqual(pairmodel.amount, 1000)
        XCTAssertEqual(pairmodel.totalAmount, 3672.50)
    }
    
    func testGetConversionOnFailure() throws {
        var errorCode: APIError?
        let promise = expectation(description: "On failure to get network list")
        sut = HomeInteractor()
        sut.connector = HomeConnectorForFailure()
        var pairmodel = PairConversionModel(base: "USD", target: "AED",conversionRate:3.6725)
        pairmodel.amount = 1000
        sut.connector?.getPairConversion(for: pairmodel, completion: { result in
            switch result {
            case .success(let model):
                pairmodel = model
            case .failure(let error):
                errorCode = error
                break
            }
            promise.fulfill()
        })
        wait(for: [promise], timeout: 10)
        XCTAssertEqual(pairmodel.base, "USD")
        XCTAssertEqual(pairmodel.target, "AED")
        XCTAssertEqual(pairmodel.conversionRate, 3.6725)
        XCTAssertEqual(pairmodel.amount, 1000)
        XCTAssertEqual(pairmodel.totalAmount, 0.0)
        XCTAssertEqual(errorCode?.localizedDescription, APIError.badURL.localizedDescription)
    }
    
}
