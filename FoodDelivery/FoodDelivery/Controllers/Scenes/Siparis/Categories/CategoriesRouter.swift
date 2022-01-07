//
//  SiparisRouter.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 27.12.2021.
//

import Foundation
import RxSwift
import UIKit


extension Reactive where Base: UIViewController {
    var showSearchViewControllerWithTitle: Binder<String> {
        Binder(base) { target, title in
            guard let tabBar = target.tabBarController else { return }
            let vc = tabBar.viewControllers?[1].children[0] as! SearchBaseViewController
            vc.searchBar.comeFromSiparisVC = title
            tabBar.selectedIndex = 1
        }
    }
}
