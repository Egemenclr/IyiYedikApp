//
//  OtherInteracting.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 10.02.2022.
//

import Foundation
import RxSwift

protocol OtherInteracting: AnyObject {
  // variables & funcs
  var presenter: OtherPresenter? { get }
  
  func getRowNames() -> Single<[RowStruct]>
}
