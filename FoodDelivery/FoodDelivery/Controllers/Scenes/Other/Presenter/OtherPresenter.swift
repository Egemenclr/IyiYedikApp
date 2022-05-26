//
//  OtherPresenter.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 10.02.2022.
//

import UIKit
import RxSwift
import RxCocoa

// know view, interactor, router
// protocol

final class OtherPresenter: OtherPresenting {
  
  weak var view: OtherView?
  private let router: OtherRouting
  private let interactor: OtherInteracting
  private let disposeBag = DisposeBag()
  
  
  let rows = BehaviorRelay<[RowStruct]>(value: [])
  
  init (
    router: OtherRouting,
    interactor: OtherInteracting
  //  view: OtherView
  ) {
    self.router = router
    self.interactor = interactor
    //self.view = view
  }
  
  func onViewDidLoad() {
    getRows()
  }
  
  func getRows() {
    interactor.getRowNames()
      .asObservable()
      .observe(on: MainScheduler.asyncInstance)
      .bind{ [weak self] rows in
        self?.view?.reloadData(with: rows)
      }
      .disposed(by: disposeBag)
  }
  
}
