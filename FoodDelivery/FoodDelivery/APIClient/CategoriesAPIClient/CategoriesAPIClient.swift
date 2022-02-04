//
//  CategoriesAPIClient.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 4.02.2022.
//

import Foundation
import RxSwift

public struct CategoriesAPIClient {
    public var categoreis : () -> Single<[RestaurantGenreModel]>
    
    init(
        categories : @escaping () -> Single<[RestaurantGenreModel]>
    ) {
        self.categoreis = categories
    }
}
