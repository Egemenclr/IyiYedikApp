//
//  LiveBasket.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 1.02.2022.
//

import Foundation
import RxSwift
import Common

public extension RestaurantAPIClient {
    static let live = Self(
        restaurants: { returnSingleNetworkRequest() }
    )
}

private extension RestaurantAPIClient {
    static func returnSingleNetworkRequest() -> Single<[RestModel]> {
        Single.create { single in
            NetworkLayer.getFirebase(entityName: "Restaurants", type: RestModel.self) { (result) in
                switch result{
                case .success(let lists):
                    single(.success(lists))
                case .failure(let error):
                    print(error)
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
