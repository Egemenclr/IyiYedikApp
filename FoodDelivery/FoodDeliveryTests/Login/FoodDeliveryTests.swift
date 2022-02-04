//
//  FoodDeliveryTests.swift
//  FoodDeliveryTests
//
//  Created by Egemen Inceler on 1.08.2021.
//

import XCTest
import RxSwift
import RxTest

@testable import FoodDelivery
import UIKit

class FoodDeliveryTests: XCTestCase {
    var scheduler: TestScheduler!
    var inputs: LoginViewModelInput!
    var outputs: LoginViewModelOutput!
    var viewModel: LoginViewModel!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        scheduler = nil
        inputs = nil
        outputs = nil
        viewModel = nil
        disposeBag = nil
        try super.tearDownWithError()
    }
    
    func test_is_loginValues_validate() {
        let username = scheduler.hot(.next(0, "egemeninceler@gmail.com"))
        let password = scheduler.hot(.next(0, "123456"))
        let buttonTapped = scheduler.hot(.next(5, ()))
        
        inputs = LoginViewModelInput(username: username,
                                     password: password,
                                     loginButtonTapped: buttonTapped,
                                     disposeBag: disposeBag)
        
        viewModel = LoginViewModel(inputs)
        outputs = viewModel.outputs(inputs)
        
        let result = scheduler.record(source: outputs.isLoginValid)
        scheduler.start()
        XCTAssertEqual(result.events, [
            .next(0, true)
        ])
    }
    
    func test_should_show_SiparisVC_after_button_click() {
        let username = scheduler.hot(.next(0, "Egemeninceler@gmail.com"))
        let password = scheduler.hot(.next(0, "Egemen15"))
        let buttonTapped = scheduler.hot(.next(5, ()))
        
        inputs = LoginViewModelInput(username: username,
                                     password: password,
                                     loginButtonTapped: buttonTapped,
                                     disposeBag: disposeBag)
        
        viewModel = LoginViewModel(inputs)
        outputs = viewModel.outputs(inputs)
        
        let mockResponse = LoginTestHelper.getMockSuccessLogin()
        let deneme = scheduler.hot(.next(5, mockResponse))
        let result = scheduler.record(source: deneme)
        scheduler.start()
        XCTAssertEqual(result.events, [
            .next(5, true)
        ])
    }
}
