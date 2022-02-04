//
//  Helpers.swift
//  FoodDeliveryTests
//
//  Created by Egemen İnceler on 27.01.2022.
//

import Foundation
import RxCocoa
@testable import FoodDelivery



struct SearchTestHelper { }

extension SearchTestHelper {
    static func getMockViewModelOutput() -> SearchViewModelOutput {
        
        let result = try! mockObject(TestModel.self, file: "fooddelivery_restaurants").restaurants
        
        return SearchViewModelOutput(
            isLoading: Driver.just(false),
            restaurant: Driver.just(result))
    }
}
