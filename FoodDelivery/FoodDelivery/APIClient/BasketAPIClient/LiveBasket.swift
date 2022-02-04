//
//  BasketLive.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 3.02.2022.
//

import Foundation
import RxSwift
import Common
import FirebaseAuth

public extension BasketAPIClient {
    static let live = Self(
        basket: { returnBasket() },
        deleteOrder: deleteFood(_:)
    )
}

private extension BasketAPIClient {
    static func returnBasket () -> Single<[RestaurantMenuModel]> {
        Single.create { single in
            guard let uuid = Auth.auth().currentUser?.uid else {
                single(.failure(NetworkError.connectionError))
                return Disposables.create()
            }
            NetworkLayer.getFirebaseWithChildWithHandler(entityName: "Basket",
                                                         child: uuid,
                                                         child2: "items",
                                                         type: RestaurantMenuModel.self) { result in
                switch result {
                case .success(let list):
                    let filtered = list.filter { word in
                        return word.isDeleted == false
                    }
                    single(.success(filtered))
                case .failure(let error):
                    print(error)
                    break
                }
            }
            return Disposables.create()
        }
    }
    
    static func deleteFood(
        _ index: Int
    ) -> Single<Bool> {
        Single.create { single in
            NetworkLayer.deleteFood(index: index)
            single(.success(true))
            return Disposables.create()
        }
    }
}
