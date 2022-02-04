//
//  RestaurantAPIClient.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 1.02.2022.
//

import Foundation
import RxSwift

public struct RestaurantAPIClient {
    public var restaurants: () -> Single<[RestModel]>
    
    init(
        restaurants: @escaping () -> Single<[RestModel]> = { .never() }
    ) {
        self.restaurants = restaurants
    }
}
