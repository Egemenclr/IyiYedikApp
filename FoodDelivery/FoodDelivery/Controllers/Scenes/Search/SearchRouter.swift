//
//  SearchRouter.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 30.12.2021.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import Common

extension Reactive where Base: UIViewController {
    var showRestaurantDetail: Binder<RestaModel> {
        Binder(base) {target, restaurant in
            let restaurantVC = RestaurantDetailVC(restaurant: restaurant)
            target.present(restaurantVC, animated: true)
        }
    }
}
