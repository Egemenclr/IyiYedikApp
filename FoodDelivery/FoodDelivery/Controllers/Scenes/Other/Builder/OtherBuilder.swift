//
//  OtherBuilder.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 11.02.2022.
//

import Foundation
import UIKit

typealias AnyView = OtherView & UIViewController
final class OtherBuilder {
  static func start() -> UIViewController {
    let router = OtherRouter()
    // assign VIP
    
    let interactor: OtherInteractor = OtherInteractor()
    let presenter: OtherPresenter = OtherPresenter(router: router,
                                                   interactor: interactor)
    
    let view: AnyView = OtherVC()
    view.presenter = presenter
    presenter.view = view
    return view
  }
}
