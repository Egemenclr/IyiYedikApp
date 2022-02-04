//
//  BasketAPIClient.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 3.02.2022.
//

import Foundation
import RxSwift

public struct BasketAPIClient {
    public var basket: () -> Single<[RestaurantMenuModel]>
    public var updateBasket: () -> Single<Bool>
    public var deleteOrder: (Int) -> Single<Bool>
    
    init (
        basket: @escaping () -> Single<[RestaurantMenuModel]> = { .never() },
        updateBasket: @escaping () -> Single<Bool> = { .never() },
        deleteOrder: @escaping (Int) -> Single<Bool> = { _ in .never() }
    ) {
        self.basket = basket
        self.updateBasket = updateBasket
        self.deleteOrder = deleteOrder
    }
}
