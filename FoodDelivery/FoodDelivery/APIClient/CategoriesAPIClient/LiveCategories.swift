//
//  LiveCategories.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 4.02.2022.
//

import Foundation
import RxSwift
import Common

public extension CategoriesAPIClient {
    static let live = Self(
        categories: { returnSingleCategories() }
    )
}

private extension CategoriesAPIClient {
    static func returnSingleCategories () -> Single<[RestaurantGenreModel]> {
        Single.create { single in
            NetworkLayer.getFirebase(entityName: "Categories", type: RestaurantGenreModel.self) { (result) in
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
