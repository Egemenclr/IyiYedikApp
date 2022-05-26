//
//  OtherView.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 10.02.2022.
//

import Foundation

protocol OtherView: AnyObject {
  var presenter: OtherPresenter? { get set }
  func reloadData(with rows: [RowStruct])
}
