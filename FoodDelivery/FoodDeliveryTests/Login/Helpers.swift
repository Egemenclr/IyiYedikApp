//
//  Helpers.swift
//  FoodDeliveryTests
//
//  Created by Egemen İnceler on 22.01.2022.
//

import Foundation

protocol LoginResponseMockable {
    static func getMockResponse() -> Bool
}

struct LoginTestHelper : LoginResponseMockable {}

extension LoginTestHelper {
    static func getMockResponse() -> Bool {
        return true
    }
    
    static func getMockSuccessLogin() -> Bool {
        return true
    }
}
